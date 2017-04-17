{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

{{ home }}/.fonts:
  file.recurse:
    - source: salt://folders/user/fonts/ttf
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755
    - file_mode: 644
