{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - folders.user.bin
  - packages.python-nautilus
  - packages.seahorse-nautilus

nautilus:
  pkg:
    - installed
  gsettings.write:
    - name: org/gnome/nautilus/preferences
    - user: {{ user }}
    - attributes:
        # default-folder-viewer: list-view
        enable-interactive-search: true
        enable-delete: true
        sort-directories-first: true

{{ home }}/.bin/refresh-thumbnails:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/nautilus/refresh-thumbnails
  pkg.installed:
    - pkgs:
      - python-gobject

{{ home }}/.local/share/nautilus-python/extensions/refresh-thumbnails.py:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/nautilus/nautilus-extensions/refresh-thumbnails.py

{{ home }}/.local/share/nautilus-python/extensions/new-file.py:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/nautilus/nautilus-extensions/new-file.py

