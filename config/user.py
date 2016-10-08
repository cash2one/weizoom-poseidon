# -*- coding: utf-8 -*-
__author__ = 'lihanyi'

import json
import time

from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.db.models import F
from django.contrib.auth.decorators import login_required
from django.contrib.auth import models as auth_models
from django.contrib.contenttypes.models import ContentType
from eaglet.utils.resource_client import Resource

from core import resource
from core.jsonresponse import create_response
import nav
from account.models import *
from customer import models as customer_models
from core.frontend_data import FrontEndData
from poseidon.settings import ZEUS_SERVICE_NAME, EAGLET_CLIENT_ZEUS_HOST

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
			user_profile = UserProfile.objects.get(user_id=user.id)
			status = user_profile.status
			user_data = {
				'id': user.id,
				'name': user.username,
				'displayName': user.first_name,
				'status': str(status),
				'selfUserName': user_profile.woid
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
	#创建账号
	def api_put(request):
		username = request.POST['name']
		password = request.POST['password']
		display_name = request.POST['display_name']
		status = int(request.POST['status'])
		woid = request.POST.get('woid','')
		
		if not check_username_valid(username):
			response = create_response(500)
			response.errMsg = u'登录账号已存在，请重新输入'
			return response.get_response()

		user = auth_models.User.objects.create_user(username, username+'@weizoom.com', password)
		auth_models.User.objects.filter(id=user.id).update(first_name=display_name)
		UserProfile.objects.filter(user_id=user.id).update(
			manager_id = request.user.id,
			status = status
			)
		if woid != '':
			UserProfile.objects.filter(user_id=user.id).update(
				woid = int(woid)
			)
		response = create_response(200)
		return response.get_response()

	@login_required
	#编辑账号
	def api_post(request):
		user_id = request.POST['id']
		username = request.POST['name']
		password = request.POST.get('password','')
		display_name = request.POST['display_name']
		status = int(request.POST['status'])
		woid = request.POST.get('woid','')
		
		user = auth_models.User.objects.get(id=user_id)
		user.username = username
		user.first_name = display_name
		if password != '':
			user.set_password(password)
		user.save()
		args = {"status":status}
		if woid != '':
			args["woid"] = int(woid)
		UserProfile.objects.filter(user_id=user.id).update(**args)
		response = create_response(200)
		return response.get_response()

	@login_required
	def api_delete(request):
		is_active = int(request.POST.get("is_active", '0')) != 0
		auth_models.User.objects.filter(id=request.POST['id']).update(is_active=is_active)
		customer_models.CustomerMessage.objects.filter(user_id=request.POST['id']).update(is_deleted=True)
		response = create_response(200)
		return response.get_response()

def check_username_valid(username):
	"""
	创建用户时，检查登录账号是否存在
	"""
	user = auth_models.User.objects.filter(username=username)
	return False if user else True


#得到所有的自营平台
class GetAllSelfShops(resource.Resource):
	app = 'config'
	resource = 'get_all_self_shops'

	@login_required
	def api_get(request):
		print 'get_all_self_shops========================='
		params = {
			'status': 'all'
		}
		resp = Resource.use(ZEUS_SERVICE_NAME, EAGLET_CLIENT_ZEUS_HOST).get(
			{
				'resource': 'panda.proprietary_account_list',
				'data': params
			}
		)
		rows = []
		if resp and resp.get('code') == 200:
			data = resp.get('data').get('profiles')
			rows = [{'text': profile.get('store_name'),
					 'value': profile.get('user_id')} for profile in data]
		data = {
			'rows': rows
		}
		response = create_response(200)
		response.data = data
		return response.get_response()