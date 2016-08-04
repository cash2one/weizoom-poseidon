# -*- coding: utf-8 -*-
import json
import time

from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.db.models import F
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import Group, User

from core import resource
from core.jsonresponse import create_response
from core import paginator
from util import db_util
import nav
import models

FIRST_NAV = 'config'
SECOND_NAV = 'config-user'

COUNT_PER_PAGE = 50

filter2field = {
	'name': 'username'
}

class Users(resource.Resource):
	app = 'config'
	resource = 'users'
	
	@login_required
	def get(request):
		"""
		响应GET
		"""
		c = RequestContext(request, {
			'first_nav_name': FIRST_NAV,
			'second_navs': nav.get_second_navs(),
			'second_nav_name': SECOND_NAV
		})
		
		return render_to_response('config/users.html', c)

	@login_required
	def api_get(request):
		#获取业务数据
		cur_page = request.GET.get('page', 1)
		users = User.objects.filter(is_active=True, id__gt=3)
		users = db_util.filter_query_set(users, request, filter2field)
		users = users.order_by('-id')
		pageinfo, users = paginator.paginate(users, cur_page, COUNT_PER_PAGE)

		#组装数据
		rows = []
		for user in users:
			rows.append({
				'id': user.id,
				'name': user.username,
				'displayName': user.first_name,
				'lastLogin': user.last_login.strftime('%Y-%m-%d %H:%M'),
				'group': u''
			})
		data = {
			'rows': rows,
			'pagination_info': pageinfo.to_dict()
		}

		#构造response
		response = create_response(200)
		response.data = data

		return response.get_response()
