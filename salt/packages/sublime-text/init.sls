{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - folders.user.local.share.fonts
  - packages.curl
  - packages.python-pip


# folders ---------------------------------------------------------------------

{{ home }}/.config/sublime-text-3:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.config/sublime-text-3/Packages:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.config/sublime-text-3/Packages/User:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

{{ home }}/.config/sublime-text-3/Installed Packages:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755

# config ----------------------------------------------------------------------

{{ home }}/.config/sublime-text-3/Packages/User/Package Control.sublime-settings:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Package Control.sublime-settings

{{ home }}/.config/sublime-text-3/Packages/User/Default (Linux).sublime-keymap:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Default (Linux).sublime-keymap

{{ home }}/.config/sublime-text-3/Packages/User/Preferences.sublime-settings:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Preferences.sublime-settings

{{ home }}/.config/sublime-text-3/Packages/User/Python.sublime-settings:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Python.sublime-settings

# desktop entry ---------------------------------------------------------------

{{ home }}/.local/share/applications/sublime_text.desktop:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/sublime_text.desktop

# themes ----------------------------------------------------------------------

{{ home }}/.config/sublime-text-3/Packages/User/Tomorrow (SL).tmTheme:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Tomorrow (SL).tmTheme

{{ home }}/.config/sublime-text-3/Packages/User/Tomorrow-Night (SL).tmTheme:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Tomorrow-Night (SL).tmTheme

{{ home }}/.config/sublime-text-3/Packages/User/Afterglow.sublime-theme:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Afterglow.sublime-theme

{{ home }}/.config/sublime-text-3/Packages/User/Afterglow-blue.sublime-theme:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Afterglow-blue.sublime-theme

{{ home }}/.config/sublime-text-3/Packages/User/Afterglow-green.sublime-theme:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Afterglow-green.sublime-theme

{{ home }}/.config/sublime-text-3/Packages/User/Afterglow-magenta.sublime-theme:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Afterglow-magenta.sublime-theme

{{ home }}/.config/sublime-text-3/Packages/User/Afterglow-orange.sublime-theme:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Afterglow-orange.sublime-theme

# extra sublime packages-------------------------------------------------------

sublime-better-tab-cycling:
  git.latest:
    - name: https://github.com/masmu/sublime-better-tab-cycling
    - target: {{ home }}/.config/sublime-text-3/Packages/sublime-better-tab-cycling
    - user: {{ user }}

sublime-typewriter:
  git.latest:
    - name: https://github.com/masmu/Typewriter
    - target: {{ home }}/.config/sublime-text-3/Packages/Typewriter
    - user: {{ user }}

# package----------------------------------------------------------------------

sublime-text:
  pkg:
    - installed
  pkgrepo.managed:
    - humanname: Sublime Text PPA
    - name: deb https://download.sublimetext.com/ apt/stable/
    - file: /etc/apt/sources.list.d/sublime-text.list
    - keyid: 1EDDE2CDFC025D17F6DA9EC0ADAE6AD28A8F901A
    - keyserver: hkp://keyserver.ubuntu.com:80
    - require_in:
      - pkg: sublime-text

# debugger support ------------------------------------------------------------

pip3-install-PdbSublimeTextSupport:
  pip.installed:
    - name: PdbSublimeTextSupport
    - bin_env: '/usr/bin/pip3'

{{ home }}/.pdbrc:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 664
    - source: salt://packages/sublime-text/pdbrc
