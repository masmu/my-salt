{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}
{% set git_config = pillar.get('git_config', None) %}

git:
  pkg:
    - installed

{% if git_config %}
{{ home }}/.gitconfig:
  file.managed: 
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 644
    - source: salt://packages/git/gitconfig
    - template: jinja
    - defaults:
        git_config: {{ git_config }}
{% endif %}