{%- from "taiga/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- taiga.server.common
- git

{{ server.virtualenv }}:
  virtualenv.manage:
  - system_site_packages: false
  - python: /usr/bin/python3.4
  - require:
    - pkg: taiga_packages
    - pkg: git_packages
    - file: taiga_dir

install_requirements:
  pip.installed:
    - requirements: {{ server.dir }}/taiga-back/requirements.txt
    - bin_env: {{ server.virtualenv }}
    - watch:
      - virtualenv: {{ server.virtualenv }}
    - require:
      - git: taiga_backend_repo
      - virtualenv: {{ server.virtualenv }}

taiga_backend_repo:
  git.latest:
  - name: {{ server.backend_source.address }}
  - target: {{ server.dir }}/taiga-back
  - rev: {{ server.backend_source.revision }}
  - require:
    - virtualenv: {{ server.virtualenv }}

taiga_backend_conf:
  file.managed:
  - name: {{ server.dir }}/taiga-back/settings/local.py
  - source: salt://taiga/files/settings.py
  - template: jinja
  - mode: 640
  - group: taiga
  - require:
    - git: taiga_backend_repo
    - file: taiga_media_dir
    - file: taiga_static_dir

taiga_media_dir:
  file.directory:
  - name: {{ server.dir }}/taiga-back/media
  - owner: taiga
  - group: taiga

taiga_static_dir:
  file.directory:
  - name: {{ server.dir }}/taiga-back/static
  - owner: taiga
  - group: taiga

setup_taiga_database:
  cmd.run:
  - names:
    - . {{ server.virtualenv }}/bin/activate; python manage.py migrate --noinput
    - . {{ server.virtualenv }}/bin/activate; python manage.py collectstatic --noinput
    - . {{ server.virtualenv }}/bin/activate; python manage.py compilemessages
  - cwd: {{ server.dir }}/taiga-back
  - user: taiga
  - creates: {{ server.dir }}/.bootstraped
  - require:
    - pip: install_requirements
    - file: taiga_backend_conf

init_taiga_database:
  cmd.wait:
  - names:
    - . {{ server.virtualenv }}/bin/activate; python manage.py loaddata initial_user
    - . {{ server.virtualenv }}/bin/activate; python manage.py loaddata initial_project_templates
    - . {{ server.virtualenv }}/bin/activate; python manage.py loaddata initial_role
    - touch {{ server.dir }}/.bootstraped
  - cwd: {{ server.dir }}/taiga-back
  - user: taiga
  - watch:
    - cmd: setup_taiga_database

{%- for plugin_name, plugin in server.get('plugin', {}).iteritems() %}
{%- if plugin.get('enabled', true) %}

{%- if plugin.source.engine == 'pip' %}
install_plugin_{{ plugin_name }}:
  pip.installed:
    - name: {{ plugin.source.name }}
    - bin_env: {{ server.virtualenv }}
    - watch:
      - virtualenv: {{ server.virtualenv }}
    - require_in:
      - cmd: setup_taiga_database
{%- endif %}

{%- endif %}
{%- endfor %}

{%- endif %}
