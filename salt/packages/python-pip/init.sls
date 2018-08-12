{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

add-pip-to-profile:
  pkg.installed:
    - pkgs:
      - python-pip
      - python3-pip
  file.append:
    - name: {{ home }}/.profile
    - text:
      - |
        if [ -d "$HOME/.local/bin" ] ; then
            PATH="$HOME/.local/bin:$PATH"
        fi

# {{ home }}/.pip:
#   file.directory:
#     - user: {{ user }}
#     - group: {{ group }}
#     - dir_mode: 775

# {{ home }}/.pip/pip.conf:
#   file.managed:
#     - user: {{ user }}
#     - group: {{ group }}
#     - mode: 644
#     - source: salt://packages/python-pip/pip.conf
