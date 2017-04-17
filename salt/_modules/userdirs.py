import contextlib
import os
import re

class UserDirParser():

    XDG_DESKTOP = 'XDG_DESKTOP_DIR'
    XDG_DOWNLOAD = 'XDG_DOWNLOAD_DIR'
    XDG_TEMPLATES = 'XDG_TEMPLATES_DIR'
    XDG_PUBLIC = 'XDG_PUBLICSHARE_DIR'
    XDG_DOCUMENTS = 'XDG_DOCUMENTS_DIR'
    XDG_PICTURES = 'XDG_PICTURES_DIR'
    XDG_MUSIC = 'XDG_MUSIC_DIR'
    XDG_VIDEOS = 'XDG_VIDEOS_DIR'

    @staticmethod
    @contextlib.contextmanager
    def open(user):
        udp = UserDirParser(user)
        udp.read()
        try:
            yield udp
        finally:
            udp.write()

    def __init__(self, user):
        self.data = {}
        self.user_home = __salt__['user.info'](user)['home']
        self.user_gid = __salt__['user.info'](user)['gid']

        user_config = self._get_user_config()
        __salt__['file.touch'](name=user_config)
        __salt__['file.check_perms'](
            name=user_config,
            ret=None, user=user, group=self.user_gid, mode=644)

    def _get_user_config(self):
        return os.path.join(self.user_home, '.config/user-dirs.dirs')

    def read(self, file_path=None):
        file_path = file_path or self._get_user_config()
        self.data = {}
        p = re.compile(ur'(.*?)="(.*?)"')
        with open(file_path) as f:
            lines = f.readlines()
            for line in lines:
                line = line.decode('utf-8')
                if line.startswith('#'):
                    continue
                match = re.match(p, line)
                if match:
                    self.data[match.group(1)] = match.group(2)

    def write(self, file_path=None):
        file_path = file_path or self._get_user_config()
        with open(file_path, 'wb') as f:
            for key, line in self.data.items():
                f.write('{}="{}"\n'.format(key, line.encode('utf-8')))

    def get(self, key, value=None):
        value = self.data.get(key, value)
        if value:
            if value == '$HOME/':
                return None
            return value.replace('$HOME', self.user_home)
        return None

    def set(self, key, value):
        if value:
            value = value.replace(self.user_home, '$HOME')
            self.data[key] = value
        else:
            self.data[key] = '$HOME/'


def _move_if_found(_from, to):
    if _from and to:
        if os.path.exists(_from) and not os.path.exists(to):
            os.rename(_from, to)

def _delete_if_exists(target):
    if os.path.exists(target):
        os.rmdir(target)
        return False
    return True

def _current_state(target, name, user, default, unused):
    _move_if_found(default, name)
    if unused is True:
        _delete_if_exists(name)
    with UserDirParser.open(user) as udp:
        return udp.get(target, None)

def _set_state(target, name, user):
    with UserDirParser.open(user) as udp:
        udp.set(target, name)
    return udp.get(target, None)


def current_desktop(name, user=None, default=None, unused=None):
    user = user or 'root'
    return _current_state(UserDirParser.XDG_DESKTOP, name, user, default, unused)

def set_desktop(name, user=None):
    user = user or 'root'
    return _set_state(UserDirParser.XDG_DESKTOP, name, user)

def current_download(name, user=None, default=None, unused=None):
    user = user or 'root'
    return _current_state(UserDirParser.XDG_DOWNLOAD, name, user, default, unused)

def set_download(name, user=None):
    user = user or 'root'
    return _set_state(UserDirParser.XDG_DOWNLOAD, name, user)

def current_pictures(name, user=None, default=None, unused=None):
    user = user or 'root'
    return _current_state(UserDirParser.XDG_PICTURES, name, user, default, unused)

def set_pictures(name, user=None):
    user = user or 'root'
    return _set_state(UserDirParser.XDG_PICTURES, name, user)

def current_videos(name, user=None, default=None, unused=None):
    user = user or 'root'
    return _current_state(UserDirParser.XDG_VIDEOS, name, user, default, unused)

def set_videos(name, user=None):
    user = user or 'root'
    return _set_state(UserDirParser.XDG_VIDEOS, name, user)

def current_music(name, user=None, default=None, unused=None):
    user = user or 'root'
    return _current_state(UserDirParser.XDG_MUSIC, name, user, default, unused)

def set_music(name, user=None):
    user = user or 'root'
    return _set_state(UserDirParser.XDG_MUSIC, name, user)

def current_documents(name, user=None, default=None, unused=None):
    user = user or 'root'
    return _current_state(UserDirParser.XDG_DOCUMENTS, name, user, default, unused)

def set_documents(name, user=None):
    user = user or 'root'
    return _set_state(UserDirParser.XDG_DOCUMENTS, name, user)

def current_public(name, user=None, default=None, unused=None):
    user = user or 'root'
    return _current_state(UserDirParser.XDG_PUBLIC, name, user, default, unused)

def set_public(name, user=None):
    user = user or 'root'
    return _set_state(UserDirParser.XDG_PUBLIC, name, user)

def current_templates(name, user=None, default=None, unused=None):
    user = user or 'root'
    return _current_state(UserDirParser.XDG_TEMPLATES, name, user, default, unused)

def set_templates(name, user=None):
    user = user or 'root'
    return _set_state(UserDirParser.XDG_TEMPLATES, name, user)