{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

add-ccat-to-profile:
  pkg.installed:
    - pkgs:
      - python-pygments
      - python3-pygments
  file.append:
    - name: {{ home }}/.profile
    - text:
      - |
        alias ccat='pygmentize -O style=monokai -f console256 -g'
