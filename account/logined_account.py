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
from account.models import *

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

		if user:
			if user.is_active:
				auth.login(request, user)
				user_info = auth_models.User.objects.filter(id=request.user.id)
				user_profile = UserProfile.objects.filter(user_id=request.user.id, status=1)
				if user_info:
					if user_profile:
						if user_info.first().is_staff:
							return HttpResponseRedirect('/config/users/')
					else:
						c = RequestContext(request, {
							'errorMsg': u'您输入的账号已停用'
						})
						return render_to_response('account/login.html', c)
				return HttpResponseRedirect('/customer/accounts/')
			else:
				c = RequestContext(request, {
					'errorMsg': u'账号已不存在'
				})
				return render_to_response('account/login.html', c)
		else:
			c = RequestContext(request, {
				'errorMsg': u'用户名或密码错误'
			})
			return render_to_response('account/login.html', c)
