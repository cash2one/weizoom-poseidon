# -*- coding: utf-8 -*-
__author__ = 'lihanyi'

import json
import time,datetime

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
from util import send_phone_msg
from eaglet.core import watchdog

import nav
from account import models as account_models
from customer import models as customer_models
import models as application_models

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
		filters = dict([(db_util.get_filter_key(key, filter2field), db_util.get_filter_value(key, request.GET)) for key in request.GET if key.startswith('__f-')])
		username = filters.get('username','')
		display_name = filters.get('displayName','')
		status = filters.get('status','')
		if username:
			filter_users = User.objects.filter(username__icontains=username, is_active=True)
			filter_users_ids = [filter_user.id for filter_user in filter_users]
			applications = applications.filter(user_id__in=filter_users_ids)
		if display_name:
			filter_users = User.objects.filter(first_name__icontains=display_name, is_active=True)
			filter_users_ids = [filter_user.id for filter_user in filter_users]
			applications = applications.filter(user_id__in=filter_users_ids)
		if status:
			filter_accounts = account_models.UserProfile.objects.filter(app_status=status)
			filter_users_ids = [filter_account.user_id for filter_account in filter_accounts]
			applications = applications.filter(user_id__in=filter_users_ids)

		pageinfo, applications = paginator.paginate(applications, cur_page, COUNT_PER_PAGE)
		user_ids = [application.user_id for application in applications]
		application_ids = [application.id for application in applications]
		server_ip_infos = customer_models.CustomerServerIps.objects.filter(customer_id__in=application_ids) #额外的ip数据
		user_infos = User.objects.filter(id__in=user_ids)
		account_infos = account_models.UserProfile.objects.filter(user_id__in=user_ids)
		reject_logs = application_models.ApplicationLog.objects.filter(user_id__in=user_ids, status=account_models.REJECT)

		#组装数据
		rows = []
		for application in applications:
			cur_user_info = user_infos.get(id=application.user_id)
			cur_account_info = account_infos.get(user_id=application.user_id)
			if cur_account_info.app_status == account_models.REJECT:
				reject_logs = reject_logs.filter(user_id=int(application.user_id))
				last_reason = reject_logs.last().reason
			server_ips = [s.name for s in server_ip_infos.filter(customer_id=application.id)]	#为毛不把ip存在一张表里。。。
			server_ips.insert(0,application.server_ip)
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
				'serverIp': server_ips,
				'interfaceUrl': application.interface_url,
				'status': account_models.APP_STATUS2NAME[cur_account_info.app_status],
				'status_value': cur_account_info.app_status,
				'reason': u'驳回原因:' + last_reason if cur_account_info.app_status == account_models.REJECT else ''
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
			is_active = False
		else:
			change_to_status = account_models.USING
			is_active = True

		try:
			customer_message = customer_models.CustomerMessage.objects.get(id=customer_id)
			user_id = customer_message.user_id
			customer_info = customer_models.CustomerMessage.objects.filter(id=customer_id)
			application_models.ApplicationLog.objects.create(
				user_id = user_id,
				customer_id = customer_id,
				status = change_to_status
				)
			account_models.UserProfile.objects.filter(user_id=user_id).update(
				app_status = change_to_status
				)

			# TODO  is_active ＝ false 时 发送异步通知 清理access token缓存
			account_models.App.objects.filter(appid=customer_message.app_id).update(is_active=is_active)
			if is_active is False:
				pass

			#向客户发送短信通知
			reason = ''
			mobile_number = customer_info.first().mobile_number
			send_phone_message(mobile_number, reason, change_to_status)

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
			customer_message = customer_models.CustomerMessage.objects.get(id=customer_id)
			user_id = customer_message.user_id
			application_models.ApplicationLog.objects.create(
				user_id = user_id,
				customer_id = customer_id,
				status = account_models.REJECT,
				reason = reason
				)
			account_models.UserProfile.objects.filter(user_id=user_id).update(
				app_status = account_models.REJECT
				)

			#向客户发送短信通知
			send_phone_message(customer_message.mobile_number, reason, account_models.REJECT)

			response = create_response(200)
			return response.get_response()
		except Exception,e:
			print e
			response = create_response(500)
			response.errMsg = u'该记录不存在，请检查'
			return response.get_response()


def send_phone_message(mobile_number, reason, status):
	if status == account_models.USING:
		reason = u'应用激活审核通过,可以正常使用'
	elif status == account_models.STOPED:
		reason = u'应用已暂停使用'
	else:
		reason = u'应用激活申请被驳回,驳回原因:' + reason

	try:
		if mobile_number:
			content = u'%s【微众传媒】' %  reason
			rs = send_phone_msg.send_phone_captcha(phones=str(mobile_number), content=content)
	except:
		watchdog.info(u"发送驳回信息异常 id：%s" % customer_id)
