import contextlib
import os
import re


class UserBookmarkParser():

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
        ubp = UserBookmarkParser(user)
        ubp.read()
        try:
            yield ubp
        finally:
            ubp.write()

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
        return os.path.join(self.user_home, '.config/gtk-3.0/bookmarks')

    def read(self, file_path=None):
        file_path = file_path or self._get_user_config()
        self.data = {}
        p = re.compile(r'(.*?)\s(.*?)$')
        with open(file_path) as f:
            lines = f.readlines()
            for line in lines:
                line = line.decode('utf-8').strip()
                if line.startswith('#'):
                    continue
                match = p.search(line)
                if match:
                    self.set(match.group(1), match.group(2))
                else:
                    self.set(line, os.path.basename(line))

    def write(self, file_path=None):
        existing = {}
        for path, value in self.data.items():
            if os.path.exists(path):
                existing[path] = value

        file_path = file_path or self._get_user_config()
        with open(file_path, 'wb') as f:
            for path, name in existing.items():
                f.write('file://{} {}\n'.format(
                    path.encode('utf-8'), name.encode('utf-8')))

    def get(self, key, value=None):
        if key.startswith('file://'):
            key = key.replace('file://', '')
        return self.data.get(key, value)

    def set(self, key, value):
        if key.startswith('file://'):
            key = key.replace('file://', '')
        self.data[key] = value


def current_bookmark(name, user=None):
    user = user or 'root'
    with UserBookmarkParser.open(user) as ubp:
        return ubp.get(name, None)


def set_bookmark(name, label, user=None):
    user = user or 'root'
    with UserBookmarkParser.open(user) as ubp:
        ubp.set(name, label)
    return ubp.get(name, None)
