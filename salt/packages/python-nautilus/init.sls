{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

python-nautilus:
  pkg.installed:
    - pkgs:
      - python-nautilus
      - python-gobject

{{ home }}/.local/share/nautilus-python:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 700

{{ home }}/.local/share/nautilus-python/extensions:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 700
