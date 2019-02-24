import configparser
import contextlib
import os
import json

class MimeParser(configparser.ConfigParser):

    SEC_DEFAULT = 'Default Applications'
    SEC_ADDED   = 'Added Associations'
    SEC_REMOVED = 'Removed Associations'

    @staticmethod
    @contextlib.contextmanager
    def open(user):
        mp = MimeParser(user)
        mp.read(mp._get_user_config())
        try:
            yield mp
        finally:
            with open(mp._get_user_config(), 'w') as f:
                mp.write(f)

    def __init__(self, user):
        configparser.ConfigParser.__init__(self)
        self.user_home = __salt__['user.info'](user)['home']
        self.user_gid = __salt__['user.info'](user)['gid']

        config_path = self._get_user_config()
        path, file_name = os.path.split(config_path)
        if not os.path.exists(path):
            __salt__['file.makedirs_perms'](
                name=path, user=user, group=self.user_gid, mode=700)
        __salt__['file.touch'](name=config_path)
        __salt__['file.check_perms'](
            name=config_path, ret=None, user=user, group=self.user_gid, mode=644)

    def _get_user_config(self):
        return os.path.join(self.user_home, '.local/share/applications/mimeapps.list')

    def read(self, *args, **kwargs):
        configparser.ConfigParser.read(self, *args, **kwargs)

        for section in [self.SEC_DEFAULT, self.SEC_ADDED, self.SEC_REMOVED]:
            if section not in self:
                self.add_section(section)

    def _str2list(self, s):
        return [s for s in s.split(';') if s != '']

    def _list2str(self, l):
        return ';'.join(l)

    def get_list(self, section, option):
        try:
            tmp = self.get(section, option)
            return self._str2list(tmp)
        except configparser.NoOptionError:
            return []

    def ensure_in(self, section, option, value, is_first=None):
        if option not in self[section]:
            self[section][option] = ''
        tmp = self._str2list(self[section][option])
        if value not in tmp:
            if is_first:
                tmp.insert(0, value)
            else:
                tmp.append(value)
        elif is_first:
            tmp.remove(value)
            tmp.insert(0, value)

        self[section][option] = self._list2str(tmp)

    def ensure_not_in(self, section, option, value):
        if option not in self[section]:
            return
        tmp = self._str2list(self[section][option])
        if value in tmp:
            tmp.remove(value)
        if len(tmp) == 0:
            self.remove_option(section, option)
        else:
            self[section][option] = self._list2str(tmp)


def current_default(option, user=None):
    user = user or 'root'
    with MimeParser.open(user) as mp:
        return mp.get_list(MimeParser.SEC_DEFAULT, option)

def set_default(option, target, user=None, is_first=None):
    user = user or 'root'
    with MimeParser.open(user) as mp:
        mp.ensure_in(MimeParser.SEC_DEFAULT, option, target, is_first)
    return mp.get_list(MimeParser.SEC_DEFAULT, option)

def current_added(option, user=None):
    user = user or 'root'
    with MimeParser.open(user) as mp:
        return mp.get_list(MimeParser.SEC_ADDED, option)

def set_added(option, target, user=None, is_first=None):
    user = user or 'root'
    with MimeParser.open(user) as mp:
        mp.ensure_in(MimeParser.SEC_ADDED, option, target, is_first)
    return mp.get_list(MimeParser.SEC_ADDED, option)

def current_removed(option, user=None):
    user = user or 'root'
    with MimeParser.open(user) as mp:
        return mp.get_list(MimeParser.SEC_REMOVED, option)

def set_removed(option, target, user=None, is_first=None):
    user = user or 'root'
    with MimeParser.open(user) as mp:
        mp.ensure_in(MimeParser.SEC_REMOVED, option, target, is_first)
    return mp.get_list(MimeParser.SEC_REMOVED, option)
