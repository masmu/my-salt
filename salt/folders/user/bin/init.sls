{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

{{ home }}/.bin:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

bin-bashrc:
  file.append:
    - name: {{ home }}/.bashrc
    - text:
      - 'export PATH="$PATH:~/.bin:~/.local/bin"'
