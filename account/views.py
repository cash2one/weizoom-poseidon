# -*- coding: utf-8 -*-

import time
from datetime import datetime
import urllib
import os
import sys
import random
try:
	from PIL import Image
except:
	import Image

from django.http import HttpResponseRedirect, HttpResponse, HttpRequest, Http404
from django.template import Context, RequestContext
from django.contrib.auth.decorators import login_required
from django.conf import settings
from django.shortcuts import render_to_response, render
from django.contrib.auth.models import User
from django.contrib import auth

from models import *
from core.jsonresponse import create_response, JsonResponse
from core.exceptionutil import unicode_full_stack
from eaglet.core import watchdog

random.seed(time.time())


#===============================================================================
# index : 用户首页
#===============================================================================
def index(request):
	user = User.objects.filter(id=request.user.id, is_active=True)
	if user:
		is_staff = user[0].is_staff
		if is_staff:
			return HttpResponseRedirect('/config/users/')
		else:
			return HttpResponseRedirect('/customer/accounts/')
	else:
		return HttpResponseRedirect('/account/login/')


# #===============================================================================
# # show_error_page : 错误页面
# #===============================================================================
# def show_error_page(request, **param_dict):
# 	#先进行异常信息的记录
# 	try:
# 		from django.views import debug
# 		settings.DEBUG = True
# 		debug_response = debug.technical_500_response(request, *sys.exc_info())
# 		settings.DEBUG = False

# 		debug_html = debug_response.content
# 		if hasattr(request, 'user'):
# 			watchdog.alert(debug_html, log_type='WEB', user_id=str(request.user.id))
# 		else:
# 			watchdog.alert(debug_html, log_type='WEB')
# 	except:
# 		alert_message = u"记录异常信息失败, cause:\n{}".format(unicode_full_stack())
# 		if hasattr(request, 'user'):
# 			watchdog.alert(alert_message, log_type='WEB', user_id=str(request.user.id))
# 		else:
# 			watchdog.alert(alert_message, log_type='WEB')

# 	is_mobile = ('/jqm/preview/' in request.META['PATH_INFO']) or ('/termite2/webapp_page/' in request.META['PATH_INFO'])
# 	if 'HTTP_REFERER' in request.META:
# 		c = RequestContext(request, {
# 			'back_url': request.META['HTTP_REFERER']
# 		})
# 	else:
# 		c = RequestContext(request, {
# 			'back_url': '#'
# 		})

# 	if is_mobile:
# 		return render(request, 'mobile_error_info.html', c, status=404)
# 	else:
# 		return render(request, 'error_info.html', c, status=404)

