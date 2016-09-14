# -*- coding: utf-8 -*-

import json
from datetime import datetime

from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.contrib.auth.decorators import login_required
from django.contrib import auth
from django.contrib.auth import models as auth_models

from core import resource
from core.jsonresponse import create_response

class LoginedAccount(resource.Resource):
	"""
	登录页面
	"""
	app = 'account'
	resource = 'logined_account'
	
	def put(request):
		username = request.POST.get('username', 'empty_username')
		password = request.POST.get('password', 'empty_password')
		user = auth.authenticate(username=username, password=password)

		if user and user.is_active:
			auth.login(request, user)
			user_info = auth_models.User.objects.filter(id=request.user.id)
			if user_info:
				if user_info.first().is_staff:
					return HttpResponseRedirect('/config/users/')
			return HttpResponseRedirect('/customer/accounts/')
		else:
			return HttpResponseRedirect('/account/login/')
