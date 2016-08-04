# -*- coding: utf-8 -*-
__author__ = 'robert'

import os



#连接app mongo
from django.conf import settings
try:
	from mongoengine import connect
	connect(settings.APP_MONGO['DB'], host=settings.APP_MONGO['HOST'])
except:
	print '[WARNING]: You have not installed mongoengine. App\'s data store will not be used. Please use "easy_install mongoengine" or "pip install mongoengine" to install it'

import dynamic_page

#
import apps
import app_list
import nav

#
files = os.listdir(settings.APPS_DIR)
files.sort()
for f in files:
	app_dir = os.path.join(settings.APPS_DIR, f)
	if app_dir.startswith('.') or os.path.isfile(app_dir):
		continue

	print '[app] import app: ', f
	module = __import__('app.apps.%s' % f, {}, {}, ['*',])
	module = __import__('app.apps.%s.urls' % f, {}, {}, ['*',])
	export_module = __import__('app.apps.%s.export' % f, {}, {}, ['*',])
	nav.add_second_nav(export_module.NAV)
