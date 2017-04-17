{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

easystroke:
  pkg:
    - installed

{{ home }}/.easystroke:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.easystroke/actions-0.5.6:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/easystroke/actions-0.5.6

{{ home }}/.easystroke/preferences-0.5.5:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/easystroke/preferences-0.5.5
