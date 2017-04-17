{% set hosts = pillar.get('hosts', None) %}

{% if hosts %}
{% for ip, host in hosts.items() %}

host-{{ host }}:
  host.present:
    - name: {{ host }}
    - ip: {{ ip }}

{% endfor %}
{% endif %}
