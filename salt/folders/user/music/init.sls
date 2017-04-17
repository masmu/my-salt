{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

{{ home }}/music:
  userdirs.music:
    - default: {{ home }}/Musik
    - user: {{ user }}
