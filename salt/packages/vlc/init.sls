{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

vlc:
  pkg:
    - installed

{{ home }}/.config/vlc:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.config/vlc/vlc-qt-interface.conf:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/vlc/vlc-qt-interface.conf

{{ home }}/.config/vlc/vlcrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 600
    - source: salt://packages/vlc/vlcrc
