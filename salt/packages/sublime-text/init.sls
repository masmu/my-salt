{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}

include:
  - packages.curl

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

{{ home }}/.config/sublime-text-3/Packages/User/Preferences.sublime-settings:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/sublime-text/Preferences.sublime-settings

# package----------------------------------------------------------------------

sublime-text:
  pkg.installed:
    - sources:
      - sublime-text: https://download.sublimetext.com/sublime-text_build-3126_amd64.deb

sublime-package-manager:
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -L https://packagecontrol.io/Package%20Control.sublime-package -o /home/{{ user }}/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package
    - creates: /home/{{ user }}/.config/sublime-text-3/Installed Packages/Package Control.sublime-package
    - user: {{ user }}
