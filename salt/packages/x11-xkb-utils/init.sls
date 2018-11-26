{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

# https://unix.stackexchange.com/questions/65434/map-superleftright-to-home-end/65923#65923

x11-xkb-utils:
  pkg:
    - installed

{{ home }}/.xkb:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 775

{{ home }}/.xkb/keymap:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 775

{{ home }}/.xkb/symbols:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 775

{{ home }}/.xkb/types:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 775

{{ home }}/.xkb/keymap/mykbd:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/x11-xkb-utils/mykbd

{{ home }}/.xkb/symbols/mysymbols:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/x11-xkb-utils/mysymbols

{{ home }}/.xkb/types/mytypes:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/x11-xkb-utils/mytypes

mykbd-bashrc:
  file.append:
    - name: {{ home }}/.bashrc
    - text:
      - |
        [ -f ~/.xkb/keymap/mykbd ] && xkbcomp -w 3 -I$HOME/.xkb ~/.xkb/keymap/mykbd $DISPLAY #LOAD_XKB

