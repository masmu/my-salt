{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - packages.tmux
  - packages.bash

byobu:
  pkg:
    - installed

{{ home }}/.byobu/.tmux.conf:
  file.symlink:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755
    - target: {{ home }}/.tmux.conf
    - force: True
    - makedirs: True