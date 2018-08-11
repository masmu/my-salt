{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}
{% set version = pillar.get('shell_version') %}

include:
  - folders.user.local.share.fonts
  - folders.user.bin
  - packages.byobu

gnome-shell:
  pkg:
    - installed

# additional binarys ----------------------------------------------------------

{{ home }}/.bin/gnome-extensions:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/gnome-shell/gnome-extensions

{{ home }}/.bin/gnome-font-scale:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/gnome-shell/gnome-font-scale

# keybindings------------------------------------------------------------------

org/gnome/mutter:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        overlay-key: 'Super_R'

org/gnome/shell:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        favorite-apps: ['firefox.desktop', 'org.gnome.Nautilus.desktop', 'gnome-terminal.desktop']
        app-picker-view: 2

org/gnome/shell/keybindings:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        toggle-overview: ['<Alt>space']

org/gnome/shell/overrides:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        dynamic-workspaces: false
        attach-modal-dialogs: false

org/gnome/desktop/interface:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        clock-show-date: true
        monospace-font-name: 'Inconsolata for Powerline Medium 11'

org/gnome/desktop/sound:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        event-sounds: false

org/gnome/desktop/background:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        show-desktop-icons: true

org/gnome/desktop/media-handling:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        automount: false
        automount-open: false

org/gnome/desktop/wm/preferences:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        button-layout: 'menu:minimize,maximize,close'
        num-workspaces: 6
        action-middle-click-titlebar: 'none'
        titlebar-font: 'Cantarell 11'

org/gnome/desktop/wm/keybindings:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        minimize: ['']
        maximize: ['', '<Super>Up', '<Primary><Alt>KP_5']
        unmaximize: ['', '<Super>Down', '<Alt>F5']
        toggle-maximized: ['']
        toggle-shaded: ['']
        begin-move: ['']
        begin-resize: ['']
        panel-main-menu: ['']
        switch-input-source: ['']
        activate-window-menu: ['']
        show-desktop: ['']
        move-to-monitor-up: ['']
        move-to-monitor-down: ['']
        move-to-monitor-right: ['']
        move-to-monitor-left: ['']
        move-to-workspace-up: ['<Control><Alt>Up']
        move-to-workspace-down: ['<Control><Alt>Down']
        move-to-workspace-right: ['']
        move-to-workspace-left: ['']
        switch-input-source-backward: ['']
        switch-to-workspace-up: ['<Control>Up']
        switch-to-workspace-down: ['<Control>Down']
        switch-to-workspace-right: ['']
        switch-to-workspace-left: ['']

# # extensions ------------------------------------------------------------------

gnome-shell-extension-native-window-placement:
  gnome-shell-extension.enabled:
    - name: native-window-placement@gnome-shell-extensions.gcampax.github.com
    - user: {{ user }}

gnome-shell-extension-places:
  gnome-shell-extension.installed:
    - eid: 8
    - version: {{ version }}
    - active: True
    - user: {{ user }}

gnome-shell-extension-clipboard-indicator:
  gnome-shell-extension.installed:
    - eid: 779
    - version: {{ version }}
    - active: True
    - user: {{ user }}
  dconf.write:
    - name: org/gnome/shell/extensions/clipboard-indicator
    - user: {{ user }}
    - attributes:
        clear-history: ['']
        prev-entry: ['']
        next-entry: ['']
        toggle-menu: ['']
        notify-on-copy: False

gnome-shell-extension-dash-to-dock:
  gnome-shell-extension.installed:
    - eid: 307
    - version: {{ version }}
    - active: True
    - user: {{ user }}

gnome-shell-extension-coverflow-alttab:
  gnome-shell-extension.installed:
    - eid: 97
    - version: {{ version }}
    - active: True
    - user: {{ user }}

gnome-shell-extension-dropdown-terminal:
  gnome-shell-extension.installed:
    - eid: 442
    - version: {{ version }}
    - active: True
    - user: {{ user }}
  pkg.installed:
    - name: byobu
  dconf.write:
    - name: org/zzrough/gs-extensions/drop-down-terminal
    - user: {{ user }}
    - attributes:
        run-custom-command: true
        scrollbar-visible: false
        first-start: false
        shortcut-type: 'other'
        terminal-size: '95%'
        custom-command: '/bin/bash -i -c "byobu"'
        real-shortcut: ['F1']

gnome-shell-extension-move-clock:
  gnome-shell-extension.installed:
    - eid: 2
    - version: {{ version }}
    - active: True
    - user: {{ user }}

gnome-shell-extension-hide-overview:
  gnome-shell-extension.installed:
    - eid: 1025
    - version: {{ version }}
    - active: True
    - user: {{ user }}

gnome-shell-extension-ghostput:
  gnome-shell-extension.installed:
    - zip: salt://files/ghostput@qos.zip
    - active: True
    - user: {{ user }}
  dconf.write:
    - name: org/gnome/shell/extensions/ghostput 
    - user: {{ user }}
    - attributes:
        toggle-key: ['<Primary>d']
