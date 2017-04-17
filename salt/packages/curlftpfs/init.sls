{% set oscodename = grains.get('oscodename') %}

curlftpfs:
  pkg:
    - installed
  pkgrepo.managed:
    - humanname: Patched
    - name: deb http://ppa.launchpad.net/qos/patched/ubuntu {{ oscodename }} main
    - file: /etc/apt/sources.list.d/qos-patched.list
    - keyid: 4869F4AF
    - keyserver: hkp://keyserver.ubuntu.com:80
    - require_in:
      - pkg: curlftpfs
