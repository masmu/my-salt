{% set user = pillar.get('user') %}
{% set group = pillar.get('group') %}
{% set home = pillar.get('home') %}
{% set twitch_oauth_token = pillar.get('twitch_oauth_token') %}

include:
  - packages.python-pip
  - folders.user.bin

livestreamer:
  pkg:
    - installed

{{ home }}/.config/livestreamer:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755
    - file_mode: 644

{{ home }}/.config/livestreamer/config:
  file.symlink:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - target: {{ home }}/.config/livestreamer/config.default
    - force: True

{{ home }}/.config/livestreamer/config.default:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644

{{ home }}/.config/livestreamer/config.default-content:
  file.append:
    - name: {{ home }}/.config/livestreamer/config.default
    - source: salt://packages/livestreamer/config.default

{% if twitch_oauth_token %}
{{ home }}/.config/livestreamer/config.default-twitch-oauth-token:
  file.append:
    - name: {{ home }}/.config/livestreamer/config.default
    - text:
      - |
        twitch-oauth-token={{ twitch_oauth_token }}
{% endif %}

{{ home }}/.config/livestreamer/config.box:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 644
    - source: salt://packages/livestreamer/config.box

{{ home }}/.bin/livestreamer-profile:
  file.managed:
    - user: {{ user }}
    - group: {{ group }}
    - mode: 755
    - source: salt://packages/livestreamer/livestreamer-profile
