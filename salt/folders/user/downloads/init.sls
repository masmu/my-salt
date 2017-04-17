{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

{{ home }}/downloads:
  userdirs.download:
    - default: {{ home }}/Downloads
    - user: {{ user }}
  userbookmarks.bookmarked:
    - label: downloads
    - user: {{ user }}