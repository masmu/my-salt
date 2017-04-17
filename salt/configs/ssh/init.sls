{% set home = pillar.get('home') %}
{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set ssh_config = pillar.get('ssh_config', None) %}
{% set ssh_keys = pillar.get('ssh_keys', None) %}

include:
  - configs.hosts

{{ home }}/.ssh:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 700

{% if ssh_config %}
{{ home }}/.ssh/config:
  file.managed: 
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 600
    - source: salt://configs/ssh/config
    - template: jinja
    - defaults:
        ssh_config: {{ ssh_config }}
{% endif %}

{% if ssh_keys %}
{% for key, config in ssh_keys.items() %}
{% if config['public'] is defined %}

{{ home }}/.ssh/{{ key }}.pub:
  file.managed:
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 644
    - contents: |
        {{ config['public'] }}

{% endif %}
{% if config['secret'] is defined %}

{{ home }}/.ssh/{{ key }}:
  file.managed:
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 600
    - contents: |
        {{ config['secret'] | indent(8) }}


{% endif %}
{% endfor %}
{% endif %}
