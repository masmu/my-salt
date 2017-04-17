{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

{% set destination = home + '/dev/seriatim' %}

include:
  - packages.python-nautilus
  - folders.user.dev

seriatim:
  pkg.installed:
    - pkgs:
      - python-gobject
      - python-dbus
      - python-notify
      - unzip
      - unrar
  archive.extracted:
    - name: {{ destination }}
    - source: salt://files/seriatim.zip
    - source_hash: md5=1a556c717fc0cfa02f42329ff8548232
    - archive_format: zip
    - user: {{ user }}
    - group: {{ group }}

{{ destination }}/seriatim:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755

/usr/local/bin/seriatim:
  file.symlink:
    - user: root
    - group: root
    - mode: 755
    - target: {{ destination }}/seriatim
    - force: True

{{ home }}/.local/share/nautilus-python/extensions/seriatim.py:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/seriatim/seriatim.py
