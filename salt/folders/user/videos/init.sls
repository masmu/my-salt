{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

{{ home }}/videos:
  userdirs.videos:
    - default: {{ home }}/Videos
    - user: {{ user }}