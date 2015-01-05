{%- from "taiga/map.jinja" import server with context %}

from .common import *

MEDIA_URL = "/media/"
STATIC_URL = "static/"
ADMIN_MEDIA_PREFIX = "/static/admin/"

# This should change if you want generate urls in emails
# for external dns.
SITES["front"]["domain"] = "localhost:8000"

DEBUG = True
TEMPLATE_DEBUG = True
PUBLIC_REGISTER_ENABLED = True

DEFAULT_FROM_EMAIL = "no-reply@example.com"
SERVER_EMAIL = DEFAULT_FROM_EMAIL

#EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
#EMAIL_USE_TLS = False
#EMAIL_HOST = "localhost"
#EMAIL_HOST_USER = ""
#EMAIL_HOST_PASSWORD = ""
#EMAIL_PORT = 25

REST_FRAMEWORK["DEFAULT_RENDERER_CLASSES"] = (
    "rest_framework.renderers.JSONRenderer",
)

DATABASES = {
    'default': {
        {%- if server.database.engine == 'mysql' %}
        'ENGINE': 'django.db.backends.mysql',
        'PORT': '3306',
        'OPTIONS': { 'init_command': 'SET storage_engine=INNODB,character_set_connection=utf8,collation_connection=utf8_unicode_ci', },
        {% else %}
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'PORT': '5432',
        {%- endif %}
        'HOST': '{{ server.database.host }}',
        'NAME': '{{ server.database.name }}',
        'PASSWORD': '{{ server.database.password }}',
        'USER': '{{ server.database.user }}'
    }
}