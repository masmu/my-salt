{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

python-pip:
  pkg:
    - installed

add-pip-to-profile:
  file.append:
    - name: {{ home }}/.profile
    - text:
      - |
        if [ -d "$HOME/.local/bin/" ] ; then
            PATH="$HOME/.local/bin/:$PATH"
        fi