{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - packages.xautomation

xbindkeys:
  pkg:
    - installed

{{ home }}/.xbindkeysrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/xbindkeys/xbindkeysrc
