{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

curl:
  pkg:
    - installed

{{ home }}/.curlrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/curl/curlrc
    - template: jinja
    - defaults:
        home: {{ home }}
