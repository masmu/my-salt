{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

{{ home }}/git:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755
  userbookmarks.bookmarked:
    - label: git
    - user: {{ user }}