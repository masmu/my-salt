def installed(name, eid=None, version=None, zip=None, active=None, user=None):
    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': '',
        'pchanges': {},
    }

    if not zip:
        if not eid or not version:
            raise salt.exceptions.SaltInvocationError(
                'Argument "eid" or "version" is missing!')

    if eid:
        metadata = __salt__['gnome-shell-extension.get_metadata_from_eid'](eid, version)
        uuid = metadata['uuid']
    if zip:
        metadata = __salt__['gnome-shell-extension.get_metadata_from_zip'](zip, version)
        uuid = metadata['uuid']
    current_state = __salt__['gnome-shell-extension.is_installed'](uuid, user)

    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': uuid if current_state else False,
            'new': '?',
        }
        ret['result'] = None
        return ret

    if current_state:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
    else:
        if eid:
            new_state = __salt__['gnome-shell-extension.install_from_eid_metadata'](metadata, user)
        if zip:
            new_state = __salt__['gnome-shell-extension.install_from_zip'](zip, metadata, user)
        if new_state:
            ret['result'] = True
            ret['comment'] = 'The state of "{0}" was changed!'.format(name)
            ret['changes'] = {
                'old': current_state,
                'new': new_state,
            }
        else:
            ret['comment'] = 'The state of "{0}" was not changed!'.format(name)

    if active is True:
        if not __salt__['gnome-shell-extension.is_enabled'](uuid, user):
            if __salt__['gnome-shell-extension.enable'](uuid, user):
                ret['result'] = True
                ret['comment'] = 'The state of "{0}" was changed!'.format(name)
                ret['changes'] = {
                    'old': 'active = false',
                    'new': 'active = true',
                }
            else:
                ret['result'] = False
                ret['comment'] = 'The state of "{}" was not changed! - ' \
                                 'The extension "{}" could not be enabled!'.format(name, uuid)
    if active is False:
        if __salt__['gnome-shell-extension.is_enabled'](uuid, user):
            if __salt__['gnome-shell-extension.disable'](uuid, user):
                ret['result'] = True
                ret['comment'] = 'The state of "{0}" was changed!'.format(name)
                ret['changes'] = {
                    'old': 'active = true',
                    'new': 'active = false',
                }
            else:
                ret['result'] = False
                ret['comment'] = 'The state of "{0}" was not changed! - ' \
                                 'The extension "{}" could not be disabled!'.format(name, uuid)
    return ret

def enabled(name, user=None):
    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': '',
        'pchanges': {},
    }

    current_state = __salt__['gnome-shell-extension.is_installed'](name, user)

    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': name if current_state else False,
            'new': '?',
        }
        ret['result'] = None
        return ret

    if current_state:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
    else:
        new_state = __salt__['gnome-shell-extension.enable'](name, user)
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

def disabled(name, user=None):
    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': '',
        'pchanges': {},
    }

    current_state = __salt__['gnome-shell-extension.is_installed'](name, user)

    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': name if current_state else False,
            'new': '?',
        }
        ret['result'] = None
        return ret

    if not current_state:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
    else:
        new_state = __salt__['gnome-shell-extension.disable'](name, user)
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
