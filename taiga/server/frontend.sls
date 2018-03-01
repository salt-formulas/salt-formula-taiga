{%- from "taiga/map.jinja" import server with context %}
{%- if server.enabled %}

include:
  - taiga.server.common
  - git

taiga_frontend_repo:
  git.latest:
  - name: {{ server.frontend_source.address }}
  - target: {{ server.dir }}/taiga-front
  - rev: {{ server.frontend_source.revision }}
  - require:
    - file: {{ server.dir }}

{{ server.dir }}/taiga-front/dist/conf.json:
  file.managed:
  - source: salt://taiga/files/conf.json
  - template: jinja
  - mode: 644
  - require:
    - git: taiga_frontend_repo

{%- endif %}
