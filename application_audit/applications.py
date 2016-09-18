# -*- coding: utf-8 -*-
__author__ = 'lihanyi'

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
from account.models import *

FIRST_NAV = 'application_audit'
SECOND_NAV = 'application-audit'

COUNT_PER_PAGE = 20

filter2field = {
}

class ApplicationAudit(resource.Resource):
	app = 'application_audit'
	resource = 'applications'
	
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
		
		return render_to_response('application_audit/application_audit.html', c)

	@login_required
	def api_get(request):
		#获取业务数据
		cur_page = request.GET.get('page', 1)
		applications = []
		applications = db_util.filter_query_set(applications, request, filter2field)
		pageinfo, applications = paginator.paginate(applications, cur_page, COUNT_PER_PAGE)

		#组装数据
		rows = []
		for application in applications:
			rows.append({
				'id': user.id,
				'username': user.username,
				'displayName': user.first_name,
				'createdAt': user.date_joined.strftime('%Y-%m-%d %H:%M'),
				'AppStatus': APP_STATUS2NAME[user_id2AppStatus[user.id]],
				'status': user_id2Status[user.id]
			})
		data = {
			'rows': rows,
			'pagination_info': pageinfo.to_dict()
		}

		#构造response
		response = create_response(200)
		response.data = data
		return response.get_response()

	@login_required
	def api_post(request):
		#更新账户状态
		user_id = request.POST.get('id','')
		try:
			UserProfile.objects.filter(user_id=user_id).update(
				status = 0
				)
			response = create_response(200)
			return response.get_response()
		except:
			response = create_response(500)
			response.errMsg = u'关闭失败，请稍后再试'
			return response.get_response()

