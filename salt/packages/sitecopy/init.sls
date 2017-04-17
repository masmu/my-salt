{% set home = pillar.get('home') %}
{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set sitecopy_config = pillar.get('sitecopy_config', None) %}

include:
  - folders.user.bin
  - folders.user.desktop
  - configs.netrc

sitecopy:
  pkg:
    - installed

{{ home }}/.sitecopy:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 700

{% if sitecopy_config %}
{{ home }}/.sitecopyrc:
  file.managed: 
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 600
    - source: salt://packages/sitecopy/sitecopyrc
    - template: jinja
    - defaults:
        sitecopy_config: {{ sitecopy_config }}
{% endif %}

{{ home }}/.bin/sync-box:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/sitecopy/sync-box