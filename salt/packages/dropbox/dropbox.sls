{% set user = pillar.get('user') %}
{% set home = pillar.get('home') %}

dropbox:
  pkg:
    - installed
  pkgrepo.managed:
    - humanname: Dropbox PPA
    - name: deb http://linux.dropbox.com/ubuntu {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/dropbox.list
    - keyid: 5044912E
    - keyserver: pgp.mit.edu
    - require_in:
      - pkg: dropbox

{{ home }}/Dropbox:
  userbookmarks.bookmarked:
    - label: dropbox
    - user: {{ user }}
