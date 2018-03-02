
=====
Taiga
=====

Project management web application with scrum in mind! Built on top of Django and AngularJ.

Dependencies
============

Other formulas:
  * https://github.com/salt-formulas/salt-formula-git

Services:
  * A database server available (PostgreSQL/MySQL)

Sample pillars
==============

Simple taiga server

.. code-block:: yaml

    taiga:
      server:
        enabled: true
        server_protocol: 'http'
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
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          user: taiga
          password: 'password'
          virtual_host: '/taiga'
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

Install ldap authentication plugin:

.. code-block:: yaml

    taiga:
      server:
        plugin:
          taiga_contrib_ldap_auth:
            enabled: true
            source:
              engine: pip
              name: taiga-contrib-ldap-auth
            parameters:
              backend:
                ldap_server: "ldaps://idm.example.com/"
                ldap_port: 636
                bind_bind_dn: uid=taiga,cn=users,cn=accounts,dc=tcpcloud,dc=eu
                bind_bind_password: password
                ldap_search_base: "cn=users,cn=accounts,dc=tcpcloud,dc=eu"
                ldap_search_property: uid
                ldap_email_property: mail
                ldap_full_name_property: displayName
              frontend:
                loginFormType: ldap

Read more
=========

* https://github.com/taigaio
* http://taigaio.github.io/taiga-doc/dist/setup-production.html

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-taiga/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-taiga

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
