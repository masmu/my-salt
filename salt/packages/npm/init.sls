{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

npm:
  pkg:
    - installed

{{ home }}/.npm:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.npmrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/npm/npmrc

add-npm-to-profile:
  file.append:
    - name: {{ home }}/.profile
    - text:
      - |
        if [ -d "$HOME/.npm/bin/" ] ; then
            PATH="$HOME/.npm/bin/:$PATH"
        fi