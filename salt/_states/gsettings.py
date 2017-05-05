import salt.exceptions
import logging

log = logging.getLogger(__name__)


def mod_init(low):
    if __grains__['os'] in ('Arch', 'Arch ARM'):
        __salt__['pkg.install']('python2-psutil')
    else:
        __salt__['pkg.install']('python-psutil')
    log.info('Installed requirements for module "{}"'.format(__name__))
    return True

def write(name, attributes, user=None):
    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': '',
        'pchanges': {},
    }

    GET_STATE_METHOD = 'gsettings.read'
    SET_STATE_METHOD = 'gsettings.write'

    current_states = {}
    for key, value in attributes.items():
        current_states[key] = __salt__[GET_STATE_METHOD](name, key, user)

    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': current_states,
            'new': '?',
        }
        ret['result'] = None
        return ret

    new_states = {}
    for key, value in attributes.items():
        if current_states[key] != value:
            try:
                new_states[key] = __salt__[SET_STATE_METHOD](name, key, value, user)
            except salt.exceptions.CommandExecutionError:
                new_states[key] = 'ERROR'
                ret['result'] = False

    # import json
    # print(json.dumps(attributes, indent=2))
    # print(json.dumps(current_states, indent=2))
    # print(json.dumps(new_states, indent=2))

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
