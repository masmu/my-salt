import salt.exceptions
import json
import psutil
import os

import process
import gvariant


def _user_settings(user=None):
    user = user or 'root'
    user_info = __salt__['user.info'](user)
    return [
        user_info.get('uid', None),
        user_info.get('gid', None),
        user_info.get('home', None),
    ]


def _get_type(name, attribute, user):
    cmd = ['gsettings', 'range', name.replace('/', '.'), attribute]
    uid, gid, home = _user_settings(user)
    proc, data = process.run_as_user(cmd, uid)
    if proc.returncode == 0:
        return data
    else:
        return None


def read(name, attribute, user=None):
    cmd = ['gsettings', 'get', name.replace('/', '.'), attribute]
    uid, gid, home = _user_settings(user)
    proc, data = process.run_as_user(cmd, uid)
    if proc.returncode == 0:
        data = gvariant.loads(data, _get_type(name, attribute, user))
        return data
    else:
        raise salt.exceptions.CommandExecutionError()


def write(name, attribute, value, user=None):
    formatted = gvariant.dumps(value)
    cmd = ['gsettings', 'set', name.replace('/', '.'), attribute, formatted]
    uid, gid, home = _user_settings(user)
    proc, data = process.run_as_user(cmd, uid)
    if proc.returncode == 0:
        return formatted
    raise salt.exceptions.CommandExecutionError()
