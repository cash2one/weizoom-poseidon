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
import models
from core.frontend_data import FrontEndData

FIRST_NAV = 'config'
SECOND_NAV = 'config-user'

GROUP_NAME_MAP = {
}

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
			group = user.groups.all()[0]
			permission_codes = [code.split('.')[1] for code in user.get_all_permissions()]
			permissions = list(auth_models.Permission.objects.filter(codename__in=permission_codes))
			permission_datas = []
			for permission in permissions:
				permission_datas.append(str(permission.id))
			user_data = {
				'id': user.id,
				'name': user.username,
				'displayName': user.first_name,
				'group': str(group.id),
				'email': user.email,
				'permissions': permission_datas
			}

			frontend_data.add('user', user_data)
		else:
			frontend_data.add('user', None)

		#获得系统所有的group数据
		groups = [group for group in auth_models.Group.objects.all() if group.name != 'SystemManager' and group.name != 'Staff']
		group_datas = []
		print '============='
		for group in groups:
			group_datas.append({
				'id': group.id,
				'name': group.name,
				'displayName': GROUP_NAME_MAP[group.name]
			})
		frontend_data.add('groups', group_datas)

		#获得系统所有的permission数据
		permission_content_type = ContentType.objects.get(name='MANAGE_SYSTEM')
		permissions = [permission for permission in auth_models.Permission.objects.filter(content_type_id=permission_content_type.id)]
		permission_datas = []
		for permission in permissions:
			if permission.codename.startswith('__manage_'):
				continue
			permission_datas.append({
				'id': permission.id,
				'name': permission.name,
				'selectable': not permission.codename.startswith('__manage_')
			})
		frontend_data.add('permissions', permission_datas)

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
		user = auth_models.User.objects.create_user(username, username+'@weizoom.com', password)
		auth_models.User.objects.filter(id=user.id).update(first_name=display_name)
		
		response = create_response(200)
		return response.get_response()

	@login_required
	def api_post(request):
		user_id = request.POST['id']
		auth_models.User.objects.filter(id=user_id).update(
			username = request.POST['name'],
			first_name = request.POST['display_name']
		)

		response = create_response(200)
		return response.get_response()

	@login_required
	def api_delete(request):
		is_active = int(request.POST.get("is_active", '0')) != 0
		auth_models.User.objects.filter(id=request.POST['id']).update(is_active=is_active)

		response = create_response(200)

		return response.get_response()
