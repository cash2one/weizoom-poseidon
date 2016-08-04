# -*- coding: utf-8 -*-
import json
import time

from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.db.models import F
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import Group, User, Permission
from django.contrib.contenttypes.models import ContentType

from core import resource
from core.jsonresponse import create_response
from core import paginator
from util import db_util
import nav
import models

FIRST_NAV = 'config'
SECOND_NAV = 'config-permission'

COUNT_PER_PAGE = 50

filter2field = {
}

class Permissions(resource.Resource):
	app = 'config'
	resource = 'permissions'
	
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
		
		return render_to_response('config/permissions.html', c)

	@login_required
	def api_get(request):
		permission_content_type = ContentType.objects.get(name='MANAGE_SYSTEM')
		permissions = [permission for permission in Permission.objects.filter(content_type_id=permission_content_type.id)]
		permission_datas = []
		for permission in permissions:
			if permission.codename.startswith('__manage_'):
				continue
			permission_datas.append({
				'id': permission.id,
				'name': permission.name,
				'codename': permission.codename
			})

		#构造response
		data = {
			'rows': permission_datas
		}
		response = create_response(200)
		response.data = data

		return response.get_response()
