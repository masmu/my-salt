{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

{{ home }}/Vorlagen:
  userdirs.templates:
    - unused: true
    - user: {{ user }}