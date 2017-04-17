{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

bash:
  pkg:
    - installed

{{ home }}/.bash:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.bash/git:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755
  pkg.installed:
    - pkgs:
      - git

base16-shell:
  git.latest:
    - name: https://github.com/chriskempson/base16-shell
    - target: {{ home }}/.bash/git/base16-shell
    - user: {{ user }}
  file.symlink:
    - name: {{ home }}/.bash/colors
    - target: {{ home }}/.bash/git/base16-shell/scripts
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755
    - force: True

{{ home }}/.bashrc:
  file.append:
    - text:
      - |
        for file in $HOME/downloads/*.m3u; do
          if [ -f "$file" ]; then
            rm "${file}"
          fi
        done

        [[ -f ~/.xmodmap.conf ]] && xmodmap ~/.xmodmap.conf #LOAD_XMODMAP
        SHELL_THEME='base16-tomorrow-night'
        [[ -e ~/.bash/colors/$SHELL_THEME.sh ]] && source ~/.bash/colors/$SHELL_THEME.sh #SHELL_THEME_LOADER
        stty -ixon #DISABLE_FLOW_CONTROL