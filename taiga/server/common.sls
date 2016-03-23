{%- from "taiga/map.jinja" import server with context %}

taiga_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

taiga_dir:
  file.directory:
  - name: {{ server.dir }}
  - user: taiga
  - group: taiga

taiga_user:
  user.present:
  - name: taiga
  - system: true
  - home: {{ server.dir }}

/var/log/taiga:
  file.directory:
  - user: root
  - group: taiga
  - mode: 775
  - makedirs: true
