import salt.exceptions
import requests
import json
import os
import zipfile
import tempfile

class DownloadFailed(Exception):
    def __init__(self, message):
        self.message = message

class GnomeShellExtensionVersionMismatch(Exception):
    def __init__(self, message):
        self.message = message

class UnzippingFailed(Exception):
    def __init__(self, message):
        self.message = message

class MetadataNotFound(Exception):
    def __init__(self, message):
        self.message = message

GNOME_EXTENSION_HOST = 'https://extensions.gnome.org'
GNOME_EXTENSION_INFO_URL = GNOME_EXTENSION_HOST + '/extension-info/?pk={}&shell_version={}'
GNOME_EXTENSION_FOLDER_PRIVATE = '.local/share/gnome-shell/extensions'
GNOME_EXTENSION_FOLDER_SYSTEM = '/usr/share/gnome-shell/extensions'

def _user_settings(user=None):
    user = user or 'root'
    user_info = __salt__['user.info'](user)
    return [
        user_info.get('uid', None),
        user_info.get('gid', None),
        user_info.get('home', None),
    ]

def _convert_salt_path(path):
    return path.replace('salt:/', __opts__['file_roots']['base'][0])

def _download_file(url, filename):
    try:
        r = requests.get(url, stream=True)
        with open(filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=1024): 
                if chunk:
                    f.write(chunk)
    except:
        raise DownloadFailed(
            'Error during downloading "{}"!'.format(url))
    return True

def _unzip(filename, target):
    try:
        zip = zipfile.ZipFile(filename)
        zip.extractall(target)
    except:
        raise UnzippingFailed(
            'Error during getting the unzipping the file "{}"'.format(filename))
    return True

def _chown(path, uid=-1, gid=-1):
    try:
        os.chown(path, uid, gid)
        for root, dirs, files in os.walk(path):
          for momo in dirs:
            os.chown(os.path.join(root, momo), uid, gid)
          for momo in files:
            os.chown(os.path.join(root, momo), uid, gid)
    except:
        return False
    return True

def get_metadata_from_eid(eid, version):
    response = requests.get(GNOME_EXTENSION_INFO_URL.format(eid, version))
    if response.status_code != 200:
        raise DownloadFailed(
            'Error during getting the extension metadata information!')
    return response.json()

def get_metadata_from_zip(zip, version):
    filepath = _convert_salt_path(zip)
    tmp_dir = tempfile.mkdtemp()
    _unzip(filepath, tmp_dir)
    with open(os.path.join(tmp_dir, 'metadata.json')) as f:
        data = json.loads(f.read())
        if version in data['shell-version']:
            raise GnomeShellExtensionVersionMismatch(
                'Wrong version of extension "{}"!'.format(data['uuid']))
        return data
    raise MetadataNotFound(
        'There was no metadata found for "{}"'.format(filepath))


def is_enabled(uuid, user=None):
    values = __salt__['gsettings.read']('org/gnome/shell', 'enabled-extensions', user)
    return uuid in values

def enable(uuid, user=None):
    values = __salt__['gsettings.read']('org/gnome/shell', 'enabled-extensions', user)
    values.append(uuid)
    __salt__['gsettings.write']('org/gnome/shell', 'enabled-extensions', values, user)
    return True

def disable(uuid, user=None):
    values = __salt__['gsettings.read']('org/gnome/shell', 'enabled-extensions', user)
    values.remove(uuid)
    __salt__['gsettings.write']('org/gnome/shell', 'enabled-extensions', values, user)
    return True

def is_installed(uuid, user=None):
    uid, gid, home = _user_settings(user)
    target1 = os.path.join(home, GNOME_EXTENSION_FOLDER_PRIVATE, uuid)
    target2 = os.path.join(GNOME_EXTENSION_FOLDER_SYSTEM, uuid)
    return os.path.isdir(target1) or os.path.isdir(target2)

def install_from_zip(zip, metadata, user=None):
    uid, gid, home = _user_settings(user)
    target = os.path.join(home, GNOME_EXTENSION_FOLDER_PRIVATE, metadata['uuid'])
    zip_path = _convert_salt_path(zip)
    _unzip(zip_path, target)
    if uid or gid:
        _chown(target, uid, gid)
    return True

def install_from_eid_metadata(metadata, user=None):
    download_url = GNOME_EXTENSION_HOST + metadata['download_url']
    tmp_file = tempfile.NamedTemporaryFile(dir='/tmp', delete=False)
    zip_path = tmp_file.name
    _download_file(download_url, zip_path)
    return install_from_zip(zip_path, metadata, user)
