{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

{{ home }}/dokumente:
  userdirs.documents:
    - default: {{ home }}/Dokumente
    - user: {{ user }}