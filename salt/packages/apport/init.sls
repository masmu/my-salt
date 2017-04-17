apport:
  pkg:
    - installed

/etc/default/apport:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://packages/apport/apport
