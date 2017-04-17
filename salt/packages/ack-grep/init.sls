ack-grep:
  pkg:
    - installed

/usr/local/bin/ack:
  file.symlink:
    - user: root
    - group: root
    - mode: 755
    - target: /usr/bin/ack-grep
    - force: True
