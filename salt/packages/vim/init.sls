{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - packages.bash

vim:
  pkg:
    - installed

{{ home }}/.vim:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.vimrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 664
    - source: salt://packages/vim/vimrc

{{ home }}/.vimrc.keycodes:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 664
    - source: salt://packages/vim/vimrc.keycodes

vim-run-plug-install:
  pkg.installed:
    - pkgs:
      - curl
      - git-core
  cmd.run:
    - name: vim +PlugInstall +qall && stty -ixon
    - user: {{ user }}
    - unless: ls {{ home }}/.vim | grep 'plugged'
