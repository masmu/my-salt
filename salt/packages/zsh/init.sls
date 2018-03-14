{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - folders.user.local.share.fonts

zsh:
  pkg:
    - installed

{{ home }}/.zsh:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 775

{{ home }}/.zshrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/zsh/zshrc

{{ home }}/.zshenv:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/zsh/zshenv

zsh-oh-my-zsh:
  git.latest:
    - name: git://github.com/robbyrussell/oh-my-zsh.git
    - target: {{ home }}/.oh-my-zsh
    - user: {{ user }}

zsh-autosuggestions:
  git.latest:
    - name: https://github.com/zsh-users/zsh-autosuggestions
    - target: {{ home }}/.zsh/zsh-autosuggestions
    - user: {{ user }}

zsh-syntax-highlighting:
  git.latest:
    - name: https://github.com/zsh-users/zsh-syntax-highlighting
    - target: {{ home }}/.zsh/zsh-syntax-highlighting
    - user: {{ user }}

zsh-history-substring-search:
  git.latest:
    - name: https://github.com/zsh-users/zsh-history-substring-search
    - target: {{ home }}/.zsh/zsh-history-substring-search
    - user: {{ user }}

zsh-history-search-multi-word:
  git.latest:
    - name: https://github.com/zdharma/history-search-multi-word
    - target: {{ home }}/.zsh/history-search-multi-word
    - user: {{ user }}
