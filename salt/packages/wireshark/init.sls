{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - folders.user.bin

wireshark:
  pkg:
    - installed

{{ home }}/.bin/capture.sh:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/wireshark/capture.sh
  pkg.installed:
    - pkgs:
      - wget

{% set group = salt['group.info']('wireshark') %}
{% if not group.get('gid', None) %}

/tmp/wireshark-debconf.config:
  file.managed:
    - source: salt://packages/wireshark/wireshark-debconf.config

dpkg-reconfigure-wireshark-common:
  cmd.run:
    - name: dpkg-reconfigure -fnoninteractive wireshark-common
    - env:
      - DEBCONF_DB_OVERRIDE: 'File{/tmp/wireshark-debconf.config}'

wireshark-groups:
  group.present:
    - name: wireshark
    - system: True
    - members:
      - {{ user }}

{% endif %}
