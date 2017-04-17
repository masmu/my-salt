{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - folders.user.bin
  - packages.xbindkeys

{{ home }}/.bin/line-ctl:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://folders/user/bin/line-ctl/line-ctl

line-ctl-bashrc:
  file.append:
    - name: {{ home }}/.xbindkeysrc
    - text:
      - |
        "{{ home }}/.bin/line-ctl +"
            m:0x1c + c:35

        "{{ home }}/.bin/line-ctl ~"
            m:0x1c + c:51

        "{{ home }}/.bin/line-ctl -"
            m:0x1c + c:61
