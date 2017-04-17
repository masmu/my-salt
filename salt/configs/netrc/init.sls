{% set home = pillar.get('home') %}
{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set netrc = pillar.get('netrc', None) %}

{% if netrc %}
{{ home }}/.netrc:
  file.managed: 
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 600
    - source: salt://configs/netrc/netrc
    - template: jinja
    - defaults:
        netrc: {{ netrc }}
{% endif %}