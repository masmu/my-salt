{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}

include:
  - folders.user.local.share.fonts

gnome-terminal:
  pkg:
    - installed

/tmp/set-gnome-terminal-font.sh:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/gnome-terminal/set-gnome-terminal-font.sh

set-gnome-terminal-font:
  cmd.run:
    - name: /tmp/set-gnome-terminal-font.sh 'Droid Sans Mono Dotted for Powerline 9'
    - user: {{ user }}
