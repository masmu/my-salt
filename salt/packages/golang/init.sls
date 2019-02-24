{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

go-packages:
  pkg.installed:
    - pkgs:
      - golang-1.10

{{ home }}/.go:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

add-go-to-profile:
  file.append:
    - name: {{ home }}/.profile
    - text:
      - |
        if [ -d "/usr/lib/go-1.10/bin" ] ; then
            PATH="/usr/lib/go-1.10/bin:$PATH"
        fi

        if [ -d "$HOME/.go" ] ; then
            export GOPATH="$HOME/.go"
        fi
        if [ -d "$HOME/.go/bin" ] ; then
            PATH="$HOME/.go/bin:$PATH"
        fi
