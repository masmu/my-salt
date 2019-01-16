{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}
{% set xkb_options = pillar.get('xkb_options', None) %}

# https://unix.stackexchange.com/questions/65434/map-superleftright-to-home-end/65923#65923

x11-xkb-utils:
  pkg:
    - installed

/usr/share/X11/xkb/symbols/mapple:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/x11-xkb-utils/mapple-symbol

/usr/share/X11/xkb/types/mapple:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/x11-xkb-utils/mapple-type

/usr/share/X11/xkb/types/complete:
  file.line:
    - mode: ensure
    - after: 'include "numpad"'
    - content: '    include "mapple"'
    - backup: True
    - show_changes: True

/usr/share/X11/xkb/rules/evdev:
  file.line:
    - mode: ensure
    - after: 'lv5:rwin_switch_lock_cancel'
    - content: 'mapple:super = +mapple(super)'
    - backup: True
    - show_changes: True

/usr/share/X11/xkb/rules/evdev.lst:
  file.line:
    - mode: ensure
    - after: 'terminate:ctrl_alt_bksp'
    - content: 'mapple:super         Use Super+Arrow keys to emulated PageUp,PageDown,Home,End,Delete'
    - backup: True
    - show_changes: True

/usr/share/X11/xkb/rules/base:
  file.line:
    - mode: ensure
    - after: 'lv5:rwin_switch_lock_cancel'
    - content: 'mapple:super = +mapple(super)'
    - backup: True
    - show_changes: True

/usr/share/X11/xkb/rules/base.lst:
  file.line:
    - mode: ensure
    - after: 'terminate:ctrl_alt_bksp'
    - content: 'mapple:super         Use Super+Arrow keys to emulated PageUp,PageDown,Home,End,Delete'
    - backup: True
    - show_changes: True

{% if xkb_options %}
org/gnome/desktop/input-sources:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        xkb-options: {{ xkb_options }}
{% endif %}
