# -*- coding: utf-8 -*-
import json
import time

from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.db.models import F
from django.contrib.auth.decorators import login_required
from django.contrib.auth import models as auth_models
from django.contrib.contenttypes.models import ContentType

from core import resource
from core.jsonresponse import create_response
import nav
from account.models import *
from core.frontend_data import FrontEndData

FIRST_NAV = 'config'
SECOND_NAV = 'config-user'

class User(resource.Resource):
	app = 'config'
	resource = 'user'
	
	@login_required
	def get(request):
		#获取用户数据
		user_id = request.GET.get('id', None)
		frontend_data = FrontEndData()
		if user_id:
			user = auth_models.User.objects.get(id=user_id)
			status = UserProfile.objects.get(user_id=user.id).status
			user_data = {
				'id': user.id,
				'name': user.username,
				'displayName': user.first_name,
				'status': str(status)
			}
			frontend_data.add('user', user_data)
		else:
			frontend_data.add('user', None)

		c = RequestContext(request, {
			'first_nav_name': FIRST_NAV,
			'second_navs': nav.get_second_navs(),
			'second_nav_name': SECOND_NAV,
			'frontend_data': frontend_data
		})
		
		return render_to_response('config/user.html', c)

	@login_required
	def api_put(request):
		username = request.POST['name']
		password = request.POST['password']
		display_name = request.POST['display_name']
		status = int(request.POST['status'])
		user = auth_models.User.objects.create_user(username, username+'@weizoom.com', password)
		auth_models.User.objects.filter(id=user.id).update(first_name=display_name)
		UserProfile.objects.filter(user_id=user.id).update(
			manager_id = request.user.id,
			status = status
			)
		response = create_response(200)
		return response.get_response()

	@login_required
	def api_post(request):
		user_id = request.POST['id']
		password = request.POST.get('password','')
		status = int(request.POST['status'])
		user = auth_models.User.objects.get(id=user_id)
		user.username = request.POST['name']
		user.first_name = request.POST['display_name']
		if password != '':
			user.set_password(password)
		user.save()
		UserProfile.objects.filter(user_id=user.id).update(status=status)
		response = create_response(200)
		return response.get_response()

	@login_required
	def api_delete(request):
		is_active = int(request.POST.get("is_active", '0')) != 0
		auth_models.User.objects.filter(id=request.POST['id']).update(is_active=is_active)

		response = create_response(200)

		return response.get_response()
