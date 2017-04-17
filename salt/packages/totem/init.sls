{% set user = pillar.get('user') %}

totem:
  pkg:
    - installed

# mimelist --------------------------------------------------------------------

totem-mimelist-default:
  mimelist.default:
    - user: {{ user }}
    - mime_types:
        audio/mpeg: totem.desktop

totem-mimelist-added:
  mimelist.added:
    - user: {{ user }}
    - mime_types:
        audio/mpeg: totem.desktop
        inode/directory: totem.desktop
