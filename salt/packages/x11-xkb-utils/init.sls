{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

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
  file.patch:
    - source: salt://packages/x11-xkb-utils/types_complete.patch
    - hash: False

/usr/share/X11/xkb/rules/evdev:
  file.patch:
    - source: salt://packages/x11-xkb-utils/rules_evdev.patch
    - hash: False

/usr/share/X11/xkb/rules/evdev.lst:
  file.patch:
    - source: salt://packages/x11-xkb-utils/rules_evdev.lst.patch
    - hash: False

/usr/share/X11/xkb/rules/base:
  file.patch:
    - source: salt://packages/x11-xkb-utils/rules_base.patch
    - hash: False

/usr/share/X11/xkb/rules/base.lst:
  file.patch:
    - source: salt://packages/x11-xkb-utils/rules_base.lst.patch
    - hash: False

org/gnome/desktop/input-sources:
  gsettings.write:
    - user: {{ user }}
    - attributes:
        xkb-options: ['altwin:swap_lalt_lwin', 'mapple:super']
