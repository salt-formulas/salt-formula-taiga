{%- from "taiga/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git
#- nodejs
#- ruby

taiga_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/srv/taiga:
  virtualenv.manage:
  - system_site_packages: false
  - python: /usr/bin/python3.4
  - requirements: salt://taiga/files/requirements.txt
  - require:
    - pkg: taiga_packages
    - pkg: git_packages

taiga_user:
  user.present:
  - name: taiga
  - home: /srv/taiga

taiga_backend_repo:
  git.latest:
  - name: {{ server.backend_source.address }}
  - target: /srv/taiga/taiga-back
  - rev: {{ server.backend_source.revision }}
  - require:
    - virtualenv: /srv/taiga

taiga_frontend_repo:
  git.latest:
  - name: {{ server.frontend_source.address }}
  - target: /srv/taiga/taiga-front
  - rev: {{ server.frontend_source.revision }}
  - require:
    - virtualenv: /srv/taiga

taiga_dir:
  file.directory:
  - name: /srv/taiga
  - user: taiga
  - group: taiga
  - require:
    - virtualenv: /srv/taiga

{#
taiga_build_dirs:
  file.directory:
  - names:
    - /srv/taiga/taiga-front/node_modules
    - /srv/taiga/taiga-front/bower_components
    - /srv/taiga/taiga-front/tmp
    - /srv/taiga/taiga-front/dist
    - /srv/taiga/taiga-front/vendor
    - /srv/taiga/taiga-front/app/vendor
  - user: taiga
  - group: taiga
  - makedirs: true
  - require:
    - git: taiga_frontend_repo
#}

/srv/taiga/conf:
  file.directory:
  - mode: 755
  - makedirs: true
  - require:
    - virtualenv: /srv/taiga

/srv/taiga/logs:
  file.directory:
  - user: taiga
  - group: taiga
  - mode: 775
  - makedirs: true
  - require:
    - virtualenv: /srv/taiga

/srv/taiga/taiga-back/settings/local.py:
  file.managed:
  - source: salt://taiga/files/settings.py
  - template: jinja
  - mode: 644
  - require:
    - git: taiga_backend_repo

/srv/taiga/conf/circus.ini:
  file.managed:
  - source: salt://taiga/files/circus.ini
  - template: jinja
  - mode: 644
  - require:
    - file: /srv/taiga/conf

init_taiga_circus:
  cmd.run:
  - name: sudo pip2 install circus

/etc/init/circus.conf:
  file.managed:
  - source: salt://taiga/files/circus.conf
  - template: jinja
  - mode: 644
  - require:
    - file: /srv/taiga/conf/circus.ini

circus_service:
  service.running: 
  - name: circus
  - enable: true
  - watch:
    - file: /etc/init/circus.conf

setup_taiga_database:
  cmd.run:
  - names:
    - . ../bin/activate; python manage.py migrate --noinput
    - . ../bin/activate; python manage.py collectstatic --noinput
  - cwd: /srv/taiga/taiga-back

init_taiga_database:
  cmd.run:
  - names:
    - . ../bin/activate; python manage.py loaddata initial_user
    - . ../bin/activate; python manage.py loaddata initial_project_templates
    - . ../bin/activate; python manage.py loaddata initial_role
  - cwd: /srv/taiga/taiga-back
  - require:
    - cmd: setup_taiga_database

{#

gulp:
  npm.installed:
  - require:
    - pkg: nodejs_packages

bower:
  npm.installed:
  - require:
    - pkg: nodejs_packages

sass:
  gem.installed:
  - require:
    - pkg: ruby_packages

scss-lint:
  gem.installed:
  - require:
    - pkg: ruby_packages

init_taiga_frontend_npm:
  cmd.run:
  - name: npm install
  - user: taiga
  - cwd: /srv/taiga/taiga-front
  - require:
    - pkg: nodejs_packages

init_taiga_frontend_bower:
  cmd.run:
  - name: bower install
  - user: taiga
  - cwd: /srv/taiga/taiga-front
  - require:
    - npm: bower

init_taiga_frontend_gulp:
  cmd.run:
  - name: gulp deploy
  - user: taiga
  - cwd: /srv/taiga/taiga-front
  - require:
    - npm: gulp

#}

/srv/taiga/taiga-front/dist/js/conf.json:
  file.managed:
  - source: salt://taiga/files/conf.json
  - template: jinja
  - mode: 644
  - require:
    - git: taiga_frontend_repo

{%- endif %}
