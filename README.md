
# Taiga

Project management web application with scrum in mind! Built on top of Django and AngularJ.

## Sample pillar

    taiga:
      server:
        enabled: true
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

## Read more

* https://github.com/taigaio
