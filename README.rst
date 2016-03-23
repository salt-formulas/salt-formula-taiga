
=====
Taiga
=====

Project management web application with scrum in mind! Built on top of Django and AngularJ.

Sample pillars
==============

Simple taiga server

.. code-block:: yaml

    taiga:
      server:
        enabled: true
        server_name: 'taiga.domain.com'
        mail_from: 'taiga@domain.com'
        secret_key: 'y5m^_^ak6+5(f.m^_^ak6+5(f.m^_^ak6+5(f.'
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
          prefix: 'CACHE_TAIGA'
        database:
          engine: 'postgresql'
          host: '127.0.0.1'
          name: 'taiga'
          password: 'password'
          user: 'taiga'
        mail:
          host: localhost
          port: 25
          encryption: none

Simple taiga server with TLS mail and authentication

.. code-block:: yaml

    taiga:
      server:
        ...
        mail:
          host: localhost
          port: 465
          user: taiga
          password: password
          encryption: tls

Simple taiga server with SSL mail

.. code-block:: yaml

    taiga:
      server:
        ...
        mail:
          host: localhost
          port: 995
          user: taiga
          password: password
          encryption: ssl

Read more
=========

* https://github.com/taigaio
* http://taigaio.github.io/taiga-doc/dist/setup-production.html
