{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

{{ home }}/.xmodmap.conf:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/xmodmap/xmodmap.conf

xmodmap-bashrc:
  file.append:
    - name: {{ home }}/.bashrc
    - text:
      - |
        [ -f ~/.xmodmap.conf ] && xmodmap ~/.xmodmap.conf #LOAD_XMODMAP
