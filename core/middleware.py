# -*- coding: utf-8 -*-
"""@package core.middleware


"""

import sys
import os
import cProfile
import time
from django.conf import settings

from django.contrib import auth
from django.contrib.auth.models import User, AnonymousUser
from django.http import HttpResponseRedirect, HttpResponse, Http404
from django.shortcuts import render_to_response
from django.template import RequestContext, Context

from core.exceptionutil import unicode_full_stack
from account.models import UserProfile	
	

class ExceptionMiddleware(object):
	def process_request(self, request):
		# 解决本地没有开启varnish，导致商品删除等操作报错
		if request.META.get('REQUEST_METHOD','') == 'PURGE':
			return HttpResponse('')

	def process_exception(self, request, exception):
		# print '>>>>>>> process exception <<<<<<<'
		# exception_stack_str = unicode_full_stack()

		# alert_message = u"request url:{}\nrequest params:\n{}\n cause:\n{}"\
		# 	.format(request.get_full_path(), request.REQUEST, exception_stack_str)
		# watchdog_alert(alert_message)

		# type, value, tb = sys.exc_info()
		# output = StringIO.StringIO()
		# print >> output, type, ' : ', value.message
		# traceback.print_tb(tb, None, output)
		# watchdog('exception', output.getvalue(), severity=WATCHDOG_ERROR)
		# output.close()

		if settings.DEBUG:
			from django.views import debug
			debug_response = debug.technical_500_response(request, *sys.exc_info())
			debug_html = debug_response.content

			dst_file = open('error.html', 'wb')
			print >> dst_file, debug_html
			dst_file.close()
			return None
		else:
			from account.views import show_error_page
			return show_error_page(request)


class ManagerDetectMiddleware(object):
	"""
	检测是否是manager的中间件
	"""
	def process_request(self, request):		
		username = request.user.username
		if username == 'manager':
			request.user.is_manager = True
		else:
			request.user.is_manager = False

		return None


class UserManagerMiddleware(object):
	"""
	确定user的manager
	"""
	def process_request(self, request):
		user = request.user
		manager = user
		if isinstance(request.user, User):
			#更改manager获取方式 duhao 20151016
			if not user.is_superuser:
				profile = user.get_profile()
				if profile.manager_id != user.id and profile.manager_id > 2:
					manager = User.objects.get(id=profile.manager_id)

			request.manager = manager
		return None


class SubUserMiddleware(object):
	"""
	SubUser middleware

	"""
	def process_request(self, request):
		if  hasattr(request, 'sub_user') and request.sub_user and User.objects.filter(id=id).count() == 0: 
			auth.logout(request)
			return HttpResponseRedirect('/login/')
		try:
			id = request.session['sub_user_id']
			if id:
				try:
					request.sub_user = User.objects.get(id=request.session['sub_user_id'])
				except:
					request.sub_user = None
					auth.logout(request)
					return HttpResponseRedirect('/login/')
			else:
				request.sub_user = None
		except:
			request.sub_user = None
			
		return None