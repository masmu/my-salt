{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - folders.user.bin

{{ home }}/.bin/watch-and-sync-dirs:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://folders/user/bin/watch-and-sync-dirs/watch-and-sync-dirs
  pkg.installed:
    - pkgs:
      - python-watchdog
      - python-docopt

