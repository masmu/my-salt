{% set user = pillar.get('user') %}

meld:
  pkg:
    - installed
  gsettings.write:
    - name: org/gnome/meld
    - user: {{ user }}
    - attributes:
        indent-width: 4
        highlight-current-line: true
        style-scheme: tango
        show-line-numbers: true
        use-system-font: true
        wrap-mode: char
        insert-spaces-instead-of-tabs: true
        highlight-syntax: true
        draw-spaces:
          - space
          - tab
          - newline
          - nbsp
          - leading
          - text
          - trailing
