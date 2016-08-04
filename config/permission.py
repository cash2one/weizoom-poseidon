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

FIRST_NAV = 'config'
SECOND_NAV = 'config-permission'

class Permission(resource.Resource):
	app = 'config'
	resource = 'permission'
	
	@login_required
	def get(request):
		c = RequestContext(request, {
			'first_nav_name': FIRST_NAV,
			'second_navs': nav.get_second_navs(),
			'second_nav_name': SECOND_NAV
		})
		
		return render_to_response('config/permission.html', c)

	@login_required
	def api_put(request):
		name = request.POST['name']
		codename = request.POST['codename']

		ctype = ContentType.objects.get(name = u'MANAGE_SYSTEM')
		permission = auth_models.Permission.objects.create(name=name, codename=codename, content_type=ctype)

		response = create_response(200)
		return response.get_response()

	@login_required
	def api_post(request):
		response = create_response(200)
		return response.get_response()

	@login_required
	def api_delete(request):
		auth_models.Permission.objects.filter(id=request.POST['id']).delete()

		response = create_response(200)
		return response.get_response()