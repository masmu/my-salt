{% set home = pillar.get('home') %}
{% set user = pillar.get('user') %}
{% set uid = pillar.get('uid') %}
{% set gid = pillar.get('gid') %}
{% set group = pillar.get('group') %}
{% set mounts = pillar.get('mounts', None) %}

include:
  - folders.user.mnt
  - configs.netrc
  - configs.hosts

{% if mounts %}
{% for mount_point, config in mounts.items() %}
{{ mount_point }}:
  mount.mounted:
{% if config['type'] == 'ftp' %}
    - device: curlftpfs#{{ config['server'] }}{{ config['remote_dir'] }}
    - opts: noauto,uid={{ uid }},gid={{ gid }},user,disable_eprt,netrc={{ home }}/.netrc
{% endif %}
{% if config['type'] == 'ssh' %}
    - device: sshfs#{{ config['user'] }}@{{ config['server'] }}:{{ config['remote_dir'] }}
    - opts: noauto,uid={{ uid }},gid={{ gid }},user,_netdev
{% endif %}
{% if config['type'] == 'smb' %}
    - device: //{{ config['server'] }}/{{ config['remote_dir'] }}
    - opts: noauto,users,passwd={{ config['remote_dir'] }}
    - fstype: cifs
{% else %}
    - fstype: fuse
{% endif %}
    - dump: 0
    - pass_num: 0
    - mkmnt: True
    - persist: True
    - mount: False
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755
{% endfor %}
{% endif %}
