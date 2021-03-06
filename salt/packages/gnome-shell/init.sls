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
        overlay-key: ''
        dynamic-workspaces: False

org/gnome/mutter/keybindings:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        toggle-tiled-right: []
        toggle-tiled-left: []

org/gnome/shell:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        favorite-apps: ['firefox.desktop', 'org.gnome.Nautilus.desktop', 'gnome-terminal.desktop']
        app-picker-view: 2
        enable-hot-corners: True

org/gnome/shell/keybindings:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        toggle-overview: ['<Super>space']
        toggle-message-tray: ['']

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
        num-workspaces: 8
        action-middle-click-titlebar: 'none'
        titlebar-font: 'Cantarell 11'

org/gnome/desktop/wm/keybindings:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        minimize: ['']
        maximize: ['', '<Primary><Alt>KP_5']
        unmaximize: ['', '<Alt>F5']
        close: ['<Alt>F4', '<Super>F4']
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
        move-to-workspace-up: ['<Primary><Super>minus']
        move-to-workspace-down: ['<Primary><Super>period']
        move-to-workspace-right: ['']
        move-to-workspace-left: ['']
        move-to-workspace-last: ['']
        move-to-workspace-1: ['']
        switch-input-source-backward: ['']
        switch-to-workspace-up: ['<Super>minus']
        switch-to-workspace-down: ['<Super>period']
        switch-to-workspace-right: ['']
        switch-to-workspace-left: ['']
        switch-to-workspace-last: ['']
        switch-to-workspace-1: ['']

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
        toggle-menu: ['<Super>v']
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
