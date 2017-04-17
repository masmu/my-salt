{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - folders.user.bin

{{ home }}/.bin/copy-drive:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://folders/user/bin/copy-drive/copy-drive


