{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

{{ home }}/desktop:
  userdirs.desktop:
    - default: {{ home }}/Schreibtisch
    - user: {{ user }}