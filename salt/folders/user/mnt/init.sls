{% set home = pillar.get('home') %}
{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set mounts = pillar.get('mounts') %}

{{ home }}/.mnt:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755
  pkg.installed:
    - pkgs:
      - curlftpfs
      - sshfs
      - cifs-utils
