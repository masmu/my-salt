import salt.exceptions
import os
import logging

log = logging.getLogger(__name__)

def bookmarked(name, label, user=None):
    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': '',
        'pchanges': {},
    }

    GET_STATE_METHOD = 'userbookmarks.current_bookmark'
    SET_STATE_METHOD = 'userbookmarks.set_bookmark'

    current_state = __salt__[GET_STATE_METHOD](name, user=user)

    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': current_state,
            'new': '?',
        }
        ret['result'] = None
        return ret

    if current_state == label:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
        return ret
    else:
        new_state = __salt__[SET_STATE_METHOD](name, label, user=user)
        if new_state == label:
            ret['result'] = True
            ret['comment'] = 'The state of "{0}" was changed!'.format(name)
            ret['changes'] = {
                'old': current_state,
                'new': new_state,
            }
        else:
            ret['comment'] = 'The state of "{0}" was not changed!'.format(name)

    return ret