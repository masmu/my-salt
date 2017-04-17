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

def list(name, user=None):
    cmd = ['dconf', 'list', '/{}/'.format(name)]
    uid, gid, home = _user_settings(user)
    proc, data = process.run_as_user(cmd, uid)
    if proc.returncode == 0:
        return data.split('\n')
    else:
        raise salt.exceptions.CommandExecutionError()


def read(name, attribute, user=None):
    cmd = ['dconf', 'read', '/{}/{}'.format(name, attribute)]
    uid, gid, home = _user_settings(user)
    proc, data = process.run_as_user(cmd, uid)
    if proc.returncode == 0:
        data = gvariant.loads(data, None)
        return data
    else:
        raise salt.exceptions.CommandExecutionError()

def write(name, attribute, value, user=None):
    formatted = gvariant.dumps(value)
    cmd = ['dconf', 'write', '/{}/{}'.format(name, attribute), formatted]
    uid, gid, home = _user_settings(user)
    proc, data = process.run_as_user(cmd, uid)
    if proc.returncode == 0:
        return formatted
    else:
        print(cmd)
    raise salt.exceptions.CommandExecutionError()

def create(name, attribute, value, user=None):
    formatted = gvariant.dumps(value)
    cmd = ['dconf', 'load', '/{}/'.format(name)]
    stdin = '[/]\n{}={}\n'.format(attribute, formatted)
    uid, gid, home = _user_settings(user)
    proc, data = process.run_as_user(cmd, uid, stdin=stdin)
    if proc.returncode == 0:
        return formatted
    else:
        pass
    raise salt.exceptions.CommandExecutionError()