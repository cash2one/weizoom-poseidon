# -*- coding: utf-8 -*-
__STRIPPER_TAG__
import json
from datetime import datetime

__STRIPPER_TAG__
from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.db.models import F
from django.contrib.auth.decorators import login_required

__STRIPPER_TAG__
from core import resource
from core import paginator
from core.jsonresponse import create_response

__STRIPPER_TAG__
import mongo_models as app_models
import export
from app import request_util

__STRIPPER_TAG__
class {{resource.class_name}}(resource.Resource):
	app = 'app.{{app_name}}'
	resource = '{{resource.lower_name}}'

	__STRIPPER_TAG__
	@login_required
	def api_post(request):
		"""
		响应POST
		"""
		target_status = request.POST['target']
		params = {}
		if target_status == 'stoped':
			target_status = app_models.STATUS_STOPED
			now = datetime.today().strftime('%Y-%m-%d %H:%M')
			params['set__end_time'] = now
		elif target_status == 'running':
			target_status = app_models.STATUS_RUNNING
		elif target_status == 'not_start':
			target_status = app_models.STATUS_NOT_START

		__STRIPPER_TAG__
		params['set__status'] = target_status
		app_models.{{resource.item_class_name}}.objects(id=request.POST['id']).update(**params)
		
		__STRIPPER_TAG__
		response = create_response(200)
		return response.get_response()