# -*- coding: utf-8 -*-

import json

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
from datetime import datetime
import nav
from util import db_util

__STRIPPER_TAG__
FIRST_NAV = 'app'
SECOND_NAV = '{{resource.second_nav}}'
COUNT_PER_PAGE = 30
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
		has_data = app_models.{{resource.item_class_name}}.objects.count()
		__STRIPPER_TAG__
		c = RequestContext(request, {
			'first_nav_name': FIRST_NAV,
			'second_navs': nav.get_second_navs(request),
			'second_nav_name': SECOND_NAV,
			'third_nav_name': "{{resource.second_nav}}",
			'has_data': has_data
		})
		__STRIPPER_TAG__
		return render_to_response('{{app_name}}/templates/editor/{{resource.lower_name}}.html', c)
	{% endif %} 

	{% if resource.actions.api_get %}
	__STRIPPER_TAG__
	@staticmethod
	def get_datas(request):
		activities = app_models.Activity.objects(owner_id=request.manager.id, is_deleted=False)
		activities = db_util.filter_query_set(activities, request)
		activities = activities.order_by('-id')
		
		__STRIPPER_TAG__
		#进行分页
		count_per_page = int(request.GET.get('count_per_page', COUNT_PER_PAGE))
		cur_page = int(request.GET.get('page', '1'))
		pageinfo, activities = paginator.paginate(activities, cur_page, count_per_page)
		
		__STRIPPER_TAG__
		return pageinfo, activities

	__STRIPPER_TAG__
	@login_required
	def api_get(request):
		"""
		响应API GET
		"""
		pageinfo, activities = {{resource.class_name}}.get_datas(request)
		
		__STRIPPER_TAG__
		items = []
		for activity in activities:
			items.append({
				'id': str(activity.id),
				'name': activity.name,
				'startTime': activity.start_time.strftime('%Y-%m-%d %H:%M'),
				'endTime': activity.end_time.strftime('%Y-%m-%d %H:%M'),
				'participantCount': activity.participant_count,
				'relatedPageId': activity.related_page_id,
				'status': activity.status_text,
				'createdAt': activity.created_at.strftime("%Y-%m-%d %H:%M")
			})

		__STRIPPER_TAG__
		response_data = {
			'rows': items,
			'pagination_info': pageinfo.to_dict()
		}
		response = create_response(200)
		response.data = response_data
		return response.get_response()		
	{% endif %}
