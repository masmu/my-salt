{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}
{% set use_vdpau = pillar.get('mpv_use_vdpau') %}

include:
  - folders.user.bin
  - folders.user.fonts
  - folders.user.pictures
  - packages.xbindkeys

mpv:
  pkg:
    - installed

/usr/local/bin/mpv:
  file.symlink:
    - user: root
    - group: root
    - mode: 755
    - target: {{ home }}/.bin/mpv
    - force: True

/usr/share/applications/mpv.desktop:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://packages/mpv/mpv.desktop

# config ----------------------------------------------------------------------

{{ home }}/.config/mpv:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.config/mpv/config:
  file.symlink:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - target: {{ home }}/.config/mpv/mpv.conf
    - force: True

{{ home }}/.config/mpv/mpv.conf:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/mpv/mpv.conf
    - template: jinja
    - defaults:
        home: {{ home }}
        use_vdpau: {{ use_vdpau }}

{{ home }}/.config/mpv/input.conf:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/mpv/input.conf

{{ home }}/.config/mpv/scripts:
    file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.config/mpv/scripts/autocrop.lua:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/mpv/scripts/autocrop.lua

{{ home }}/.config/mpv/scripts/autodeint.lua:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/mpv/scripts/autodeint.lua

{{ home }}/.config/mpv/scripts/notify.lua:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/mpv/scripts/notify.lua

{{ home }}/.config/mpv/scripts/stats.lua:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/mpv/scripts/stats.lua

{{ home }}/.config/mpv/scripts/meta-screenshot.lua: 
  file.managed: 
    - user: {{ user }} 
    - group: {{ group }} 
    - mode: 644
    - source: salt://packages/mpv/scripts/meta-screenshot.lua
    - template: jinja
    - defaults:
        home: {{ home }}

# folders ---------------------------------------------------------------------

{{ home }}/bilder/shots:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

# scripts ---------------------------------------------------------------------

{{ home }}/.bin/mpv:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/mpv/mpv
  pkg.installed:
    - pkgs:
      - python-pil

{{ home }}/.bin/set-image-meta:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/mpv/set-image-meta
  pkg.installed:
    - pkgs:
      - python-docopt
      - python-pil

{{ home }}/.bin/show-image-meta:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/mpv/show-image-meta
  pkg.installed:
    - pkgs:
      - python-docopt
      - python-pil

# mimelist --------------------------------------------------------------------

mpv-mimelist-default:
  mimelist.default:
    - user: {{ user }}
    - mime_types:
        video/mp4: mpv.desktop
        video/x-matroska: mpv.desktop
        video/x-msvideo: mpv.desktop
        video/quicktime: mpv.desktop
        video/x-ms-wmv: mpv.desktop
        video/x-flv: mpv.desktop

mpv-mimelist-added-first:
  mimelist.added_first:
    - user: {{ user }}
    - mime_types:
        inode/directory: mpv.desktop
        image/png: mpv.desktop

mpv-mimelist-added:
  mimelist.added:
    - user: {{ user }}
    - mime_types:
        video/mp4: mpv.desktop
        video/x-matroska: mpv.desktop
        video/x-msvideo: mpv.desktop
        video/quicktime: mpv.desktop
        video/x-ms-wmv: mpv.desktop
        video/x-flv: mpv.desktop
