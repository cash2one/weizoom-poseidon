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
from account import models as account_models
from customer import models as customer_models

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
		applications = customer_models.CustomerMessage.objects.filter(is_deleted=False)
		applications = db_util.filter_query_set(applications, request, filter2field)
		pageinfo, applications = paginator.paginate(applications, cur_page, COUNT_PER_PAGE)
		user_ids = [application.user_id for application in applications]
		user_infos = User.objects.filter(id__in=user_ids)
		#组装数据
		rows = []
		for application in applications:
			cur_user_info = user_infos.get(id=application.user_id)
			rows.append({
				'id': application.id,
				'username': cur_user_info.username,
				'displayName': cur_user_info.first_name,
				'appName': u'默认应用',
				'appId': application.app_id if application.app_id else u'审核后自动生成',
				'appSecret': application.app_secret if application.app_secret else u'审核后自动生成',
				'DeveloperName': application.name,
				'phone': application.mobile_number,
				'email': application.email,
				'serverIp': application.server_ip,
				'interfaceUrl': application.interface_url,
				'status': account_models.APP_STATUS2NAME[application.status],
				'reason': u'驳回原因：' + application.reason if application.reason else ''
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
		#通过审核/暂时停用
		customer_id = request.POST.get('id','')
		status = request.POST.get('method','')
		if status == 'close':
			change_to_status = account_models.STOPED
		else:
			change_to_status = account_models.USING
		try:
			user_id = customer_models.CustomerMessage.objects.get(id=customer_id).user_id
			customer_info = customer_models.CustomerMessage.objects.filter(id=customer_id)
			customer_info.update(
				status = change_to_status
				)
			account_models.UserProfile.objects.filter(user_id=user_id).update(
				app_status = change_to_status
				)

			#没有app_id等数据
			if not customer_info.first().app_id and status == 'open':
				customer_info.update(
					app_id = '1111111111',
					app_secret = 'sd124wr45sfds'
					)

			response = create_response(200)
			return response.get_response()
		except:
			response = create_response(500)
			response.errMsg = u'关闭失败，请稍后再试'
			return response.get_response()

	@login_required
	def api_put(request):
		#驳回
		customer_id = request.POST.get('id','')
		reason = request.POST.get('reason','')
		try:
			user_id = customer_models.CustomerMessage.objects.get(id=customer_id).user_id
			customer_models.CustomerMessage.objects.filter(id=customer_id).update(
				status = account_models.REJECT,
				reason = reason
				)
			account_models.UserProfile.objects.filter(user_id=user_id).update(
				app_status = account_models.REJECT
				)
			response = create_response(200)
			return response.get_response()
		except:
			response = create_response(500)
			response.errMsg = u'该记录不存在，请检查'
			return response.get_response()

