{% set home = pillar.get('home') %}
{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set dput_config = pillar.get('dput_config', None) %}

dput:
  pkg:
    - installed

{% if dput_config %}
{{ home }}/.dput.cf:
  file.managed: 
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 644
    - source: salt://packages/dput/dput.cf
    - template: jinja
    - defaults:
        dput_config: {{ dput_config }}
{% endif %}