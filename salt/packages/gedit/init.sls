{% set user = pillar.get('user') %}

gedit:
  pkg:
    - installed
  gsettings.write:
    - name: org/gnome/gedit/preferences/editor
    - user: {{ user }}
    - attributes:
        highlight-current-line: true
        display-right-margin: true
        display-overview-map: false
        bracket-matching: true
        scheme: tango
        tabs-size: 4
        display-line-numbers: true
        insert-spaces: true
        right-margin-position: 79
        background-pattern: none
        wrap-last-split-mode: word

gedit-plugins:
  pkg:
    - installed
  gsettings.write:
    - name: org/gnome/gedit/plugins
    - user: {{ user }}
    - attributes:
        active-plugins:
          - codecomment
          - smartspaces
          - wordcompletion
          - modelines
          - findinfiles
          - filebrowser
          - bracketcompletion
