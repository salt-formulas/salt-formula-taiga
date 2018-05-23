{%- from "taiga/map.jinja" import server with context %}
{%- if server.enabled %}

include:
  - taiga.server.common

taiga_events_repo:
  git.latest:
  - name: {{ server.events_source.address }}
  - target: {{ server.dir }}/taiga-events
  - rev: {{ server.events_source.revision }}
  - require:
    - file: {{ server.dir }}

taiga_events_conf:
  file.managed:
  - name: {{ server.dir }}/taiga-events/config.json
  - source: salt://taiga/files/events_config.json
  - template: jinja
  - mode: 644
  - require:
    - git: taiga_events_repo

taiga_events_npm:
  cmd.run:
    - name: npm install
    - cwd: {{ server.dir }}/taiga-events
    - creates: {{ server.dir }}/taiga-events/node_modules
    - watch:
      - git: taiga_events_repo

{%- if grains.init == "systemd" %}
taiga_events_systemd:
  file.managed:
    - name: /etc/systemd/system/taiga-events.service
    - source: salt://taiga/files/taiga-events.service
    - template: jinja

taiga_events_service:
  service.running:
    - name: taiga-events
    - enable: true
    - watch:
      - git: taiga_events_repo
      - file: taiga_events_conf
      - cmd: taiga_events_npm
      - file: taiga_events_systemd
{%- endif %}

{%- endif %}
