import salt.exceptions
import os
import logging

log = logging.getLogger(__name__)


def mod_init(low):
    __salt__['pkg.install']('python-configparser')
    log.info('Installed requirements for module "{}"'.format(__name__))
    return True

def _verify_state(action, name, mime_type, target, user=None, is_first=None):
    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': '',
        'pchanges': {},
    }

    GET_STATE_METHOD = 'mimelist.current_{}'.format(action)
    SET_STATE_METHOD = 'mimelist.set_{}'.format(action)

    current_state = __salt__[GET_STATE_METHOD](mime_type, user=user)

    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': current_state,
            'new': '?',
        }
        ret['result'] = None
        return ret

    if is_first and len(current_state) > 0 and target == current_state[0]:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
        return ret
    elif not is_first and target in current_state:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
        return ret
    else:
        new_state = __salt__[SET_STATE_METHOD](
            mime_type, target, user=user, is_first=is_first)
        if new_state:
            ret['result'] = True
            ret['comment'] = 'The state of "{0}" was changed!'.format(name)
            ret['changes'] = {
                'old': current_state,
                'new': new_state,
            }
        else:
            ret['comment'] = 'The state of "{0}" was not changed!'.format(name)

    return ret

def _verify_states(action, name, mime_types, user=None, is_first=None):
    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': '',
        'pchanges': {},
    }

    GET_STATE_METHOD = 'mimelist.current_{}'.format(action)
    SET_STATE_METHOD = 'mimelist.set_{}'.format(action)

    current_states = {}
    for mime_type, target in mime_types.items():
        current_states[mime_type] = __salt__[GET_STATE_METHOD](
            mime_type, user=user)

    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': current_state,
            'new': '?',
        }
        ret['result'] = None
        return ret

    new_states = {}
    for mime_type, target in mime_types.items():
        if is_first and len(current_states[mime_type]) > 0 and target == current_states[mime_type][0]:
            pass
        elif not is_first and target in current_states[mime_type]:
            pass
        else:
            new_states[mime_type] = __salt__[SET_STATE_METHOD](
                mime_type, target, user=user, is_first=is_first)

    if len(new_states) == 0:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
    else:
        ret['comment'] = 'The state of "{0}" was changed!'.format(name)
        ret['changes'] = {
            'old': current_states,
            'new': new_states,
        }
    return ret

def _state_operation(action, name, mime_type, target, mime_types, user, is_first):
    if mime_type and target:
        return _verify_state(action, name, mime_type, target, user, is_first)
    elif mime_types:
        return _verify_states(action, name, mime_types, user, is_first)
    else:
        raise salt.exceptions.SaltInvocationError(
            'Argument "mime_types" or "mime_type,target" needed.')

def default(name, mime_type=None, target=None, mime_types=None, user=None, is_first=None):
    return _state_operation('default', name, mime_type, target, mime_types, user, is_first)

def default_first(name, mime_type=None, target=None, mime_types=None, user=None):
    return _state_operation('default', name, mime_type, target, mime_types, user, True)

def added(name, mime_type=None, target=None, mime_types=None, user=None, is_first=None):
    return _state_operation('added', name, mime_type, target, mime_types, user, is_first)

def added_first(name, mime_type=None, target=None, mime_types=None, user=None):
    return _state_operation('added', name, mime_type, target, mime_types, user, True)

def removed(name, mime_type=None, target=None, mime_types=None, user=None, is_first=None):
    return _state_operation('removed', name, mime_type, target, mime_types, user, is_first)