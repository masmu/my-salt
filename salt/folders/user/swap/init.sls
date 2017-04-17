{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

{{ home }}/swap:
  userdirs.public:
    - default: {{ home }}/Öffentlich
    - user: {{ user }}
  userbookmarks.bookmarked:
    - label: swap
    - user: {{ user }}