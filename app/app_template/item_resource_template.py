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
import nav
from core.frontend_data import FrontEndData

__STRIPPER_TAG__
FIRST_NAV = 'app'
SECOND_NAV = '{{resource.second_nav}}'
COUNT_PER_PAGE = 20
__STRIPPER_TAG__
class {{resource.class_name}}(resource.Resource):
	app = 'app.{{app_name}}'
	resource = '{{resource.lower_name}}'

	{% if resource.actions.get %}
	__STRIPPER_TAG__
	@login_required
	def get(request):
		"""
		响应GET
		"""
		if 'id' in request.GET:
			project_id = 'new_app:{{app_name}}:%s' % request.GET.get('related_page_id', 0)
			#处理删除异常
			try:
				{{resource.lower_name}} = app_models.{{resource.class_name}}.objects.get(id=request.GET['id'])
				{{resource.lower_name}} = {
					"id": str({{resource.lower_name}}.id),
					"name": {{resource.lower_name}}.name,
					"startTime": {{resource.lower_name}}.start_time.strftime("%Y-%m-%d %H:%M"),
					"endTime": {{resource.lower_name}}.end_time.strftime("%Y-%m-%d %H:%M")
				}
			except:
				c = RequestContext(request, {
					'first_nav_name': FIRST_NAV,
					'second_navs': nav.get_second_navs(request),
					'second_nav_name': SECOND_NAV,
					'is_deleted_data': True
				})
				__STRIPPER_TAG__
				{% if resource.enable_wepage %}
				return render_to_response('{{app_name}}/templates/editor/workbench.html', c)
				{% else %}
				return render_to_response('{{app_name}}/templates/editor/{{resource.lower_name}}.html', c)
				{% endif %}

			__STRIPPER_TAG__
			{% if resource.enable_wepage %}
			is_create_new_data = False

			{% endif %}
		else:
			{{resource.lower_name}} = None
			{% if resource.enable_wepage %}
			is_create_new_data = True
			project_id = 'new_app:{{app_name}}:0'
			{% endif %}

		__STRIPPER_TAG__
		frontend_data = FrontEndData()
		frontend_data.add('activity', activity)

		c = RequestContext(request, {
			'first_nav_name': FIRST_NAV,
			'second_navs': nav.get_second_navs(request),
			'second_nav_name': SECOND_NAV,
			'frontend_data': frontend_data,
			{% if resource.enable_wepage %}
			'is_create_new_data': is_create_new_data,
			'project_id': project_id,
			{% endif %}
		})
		__STRIPPER_TAG__
		{% if resource.enable_wepage %}
		return render_to_response('{{app_name}}/templates/editor/workbench.html', c)
		{% else %}
		return render_to_response('{{app_name}}/templates/editor/{{resource.lower_name}}.html', c)
		{% endif %}
	{% endif %}

	{% if resource.actions.api_get %}
	__STRIPPER_TAG__
	@login_required
	def api_get(request):
		"""
		响应GET api
		"""
		if 'id' in request.GET:
			{{resource.lower_name}} = app_models.{{resource.class_name}}.objects.get(id=request.GET['id'])
			data = {{resource.lower_name}}.to_json()
		else:
			data = {}

		response = create_response(200)
		response.data = data
		return response.get_response()
	{% endif %} 

	{% if resource.actions.api_put %}
	__STRIPPER_TAG__
	{% if not resource.is_participance %}
	@login_required
	{% endif %}
	def api_put(request):
		"""
		响应PUT
		"""
		data = request_util.get_fields_to_be_save(request)

		__STRIPPER_TAG__
		#处理开启时间小于当前时间的活动
		now = datetime.today()
		start_time = datetime.strptime(request.POST['start_time'], '%Y-%m-%d %H:%M')
		if now > start_time:
			data['status'] = app_models.STATUS_RUNNING
		__STRIPPER_TAG__	
		{{resource.lower_name}} = app_models.{{resource.class_name}}(**data)
		{{resource.lower_name}}.save()
		error_msg = None
		{% if resource.is_participance %}
		__STRIPPER_TAG__
		#调整参与数量
		app_models.{{resource.item_class_name}}.objects(id=data['belong_to']).update(**{"inc__participant_count":1})
		__STRIPPER_TAG__
		{% endif %}
		__STRIPPER_TAG__
		data = json.loads({{resource.lower_name}}.to_json())
		data['id'] = data['_id']['$oid']
		if error_msg:
			data['error_msg'] = error_msg
		response = create_response(200)
		response.data = data
		return response.get_response()
	{% endif %}

	{% if resource.actions.api_post %}
	__STRIPPER_TAG__
	@login_required
	def api_post(request):
		"""
		响应POST
		"""
		data = request_util.get_fields_to_be_save(request)
		update_data = {}
		update_fields = set(['name', 'start_time', 'end_time'])
		for key, value in data.items():
			if key in update_fields:
				update_data['set__'+key] = value
		
		app_models.{{resource.class_name}}.objects(id=request.POST['id']).update(**update_data)
		__STRIPPER_TAG__
		response = create_response(200)
		return response.get_response()
	{% endif %}

	{% if resource.actions.api_delete %}
	__STRIPPER_TAG__
	@login_required
	def api_delete(request):
		"""
		响应DELETE
		"""
		app_models.{{resource.class_name}}.objects(id=request.POST['id']).update(set__is_deleted=True)
		__STRIPPER_TAG__
		response = create_response(200)
		return response.get_response()
	{% endif %}
