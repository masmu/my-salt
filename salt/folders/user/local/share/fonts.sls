{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - packages.git

pull-powerline-fonts:
  git.latest:
    - name: https://github.com/powerline/fonts.git
    - target: /tmp/powerline-fonts
    - unless: ls {{ home }}/.local/share/fonts | grep 'Space Mono Bold for Powerline.ttf'
    - user: {{ user }}

install-powerline-fonts:
  cmd.run:
    - name: /tmp/powerline-fonts/install.sh
    - user: {{ user }}
    - require:
      - git: pull-powerline-fonts
    - creates: {{ home }}/.local/share/fonts/Space Mono Bold for Powerline.ttf
