{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

{{ home }}/.icons:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 775
