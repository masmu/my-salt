{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}
{% set gnupg_config = pillar.get('gnupg_config', None) %}

gnupg:
  pkg:
    - installed

{{ home }}/.gnupg:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 700

{{ home }}/.gnupg/gpg.conf:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 600
    - source: salt://packages/gnupg/gpg.conf

{% if gnupg_config %}
{% for key, config in gnupg_config.items() %}
{% for key_type in ['public', 'secret'] %}
{% if config[key_type] is defined %}
{% set command = 'gpg --homedir={}/.gnupg --list-{}-keys {}'.format(home, key_type, key) %}
{% if salt['cmd.retcode'](command, runas=user) != 0 %}
{% set key_path = '{}/gpg-{}-{}.sec'.format(home, key, key_type) %}

{{ key_path }}:
  file.managed:
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 600
    - contents: |
        {{ config[key_type] | indent(8) }}

import-gpg-{{ key_type }}-{{ key }}:
  cmd.run:
    - name: gpg --import {{ key_path }} && rm {{ key_path }}
    - user: {{ user }}

{% endif %}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
