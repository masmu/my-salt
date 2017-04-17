{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

{{ home }}/bilder:
  userdirs.pictures:
    - default: {{ home }}/Bilder
    - user: {{ user }}
  userbookmarks.bookmarked:
    - label: bilder
    - user: {{ user }}