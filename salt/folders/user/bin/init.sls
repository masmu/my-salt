{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

{{ home }}/.bin:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

add-bin-to-profile:
  file.append:
    - name: {{ home }}/.profile
    - text:
      - |
        if [ -d "$HOME/.bin/" ] ; then
            PATH="$HOME/.bin/:$PATH"
        fi