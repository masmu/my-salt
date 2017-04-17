import salt.exceptions
import os
import logging

log = logging.getLogger(__name__)

def _verify_state(action, name, user, default=None, unused=None):
    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': '',
        'pchanges': {},
    }

    GET_STATE_METHOD = 'userdirs.current_{}'.format(action)
    SET_STATE_METHOD = 'userdirs.set_{}'.format(action)

    current_state = __salt__[GET_STATE_METHOD](
        name, user=user, default=default, unused=unused)

    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': current_state,
            'new': '?',
        }
        ret['result'] = None
        return ret

    if current_state == name:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
        return ret
    else:
        new_state = __salt__[SET_STATE_METHOD](name, user=user)
        if new_state == name:
            ret['result'] = True
            ret['comment'] = 'The state of "{0}" was changed!'.format(name)
            ret['changes'] = {
                'old': current_state,
                'new': new_state,
            }
        else:
            ret['comment'] = 'The state of "{0}" was not changed!'.format(name)

    return ret

def desktop(name, user=None, default=None, unused=None):
    return _verify_state('desktop', name, user, default, unused)

def download(name, user=None, default=None, unused=None):
    return _verify_state('download', name, user, default, unused)

def pictures(name, user=None, default=None, unused=None):
    return _verify_state('pictures', name, user, default, unused)

def videos(name, user=None, default=None, unused=None):
    return _verify_state('videos', name, user, default, unused)

def music(name, user=None, default=None, unused=None):
    return _verify_state('music', name, user, default, unused)

def public(name, user=None, default=None, unused=None):
    return _verify_state('public', name, user, default, unused)

def documents(name, user=None, default=None, unused=None):
    return _verify_state('documents', name, user, default, unused)

def templates(name, user=None, default=None, unused=None):
    return _verify_state('templates', name, user, default, unused)