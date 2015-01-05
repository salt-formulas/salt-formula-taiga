
import sys

sys.stdout = sys.stderr

import site

site.addsitedir('/srv/django_enc/lib/python2.7/site-packages')

import os

sys.path.append('/srv/django_enc/enc')
sys.path.append('/srv/django_enc/horizon')
sys.path.append('/srv/django_enc/site')

os.environ['DJANGO_SETTINGS_MODULE'] = 'core.settings'

import django.core.handlers.wsgi

application = django.core.handlers.wsgi.WSGIHandler()
