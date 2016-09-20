# -*- coding: utf-8 -*-
import json
import time
import base64

from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.contrib.auth.decorators import login_required

from core import resource
from core.jsonresponse import create_response
import nav
import models
from account import models as account_models
from application_audit import models as application_audit_models

FIRST_NAV = 'customer'
SECOND_NAV = 'customer-accounts'


class Accounts(resource.Resource):
	app = 'customer'
	resource = 'accounts'

	@login_required
	def get(request):
		"""
		响应GET
		"""
		user_profile = account_models.UserProfile.objects.filter(user=request.user)
		status = 0 if not user_profile else user_profile[0].app_status
		c = RequestContext(request, {
			'first_nav_name': FIRST_NAV,
			'second_navs': nav.get_second_navs(),
			'second_nav_name': SECOND_NAV,
			'status': status
		})
		
		return render_to_response('customer/accounts.html', c)

	@login_required
	def api_get(request):
		customer_message = models.CustomerMessage.objects.get(user=request.user)
		user_profile = account_models.UserProfile.objects.filter(user=request.user)
		application_logs = application_audit_models.ApplicationLog.objects.filter(user_id=request.user.id).order_by('review_time')
		# logs = []
		# for application_log in application_logs:
		# 	logs.append({
		# 		'status': application_log.status,
		# 		'reason': application_log.reason,
		# 		'reviewTime': application_log.review_time.strftime("%Y-%m-%d")
		# 	})
		logs = [{
			'status': application_log.status,
			'reason': application_log.reason,
			'reviewTime': application_log.review_time.strftime("%Y-%m-%d")
		} for application_log in application_logs]

		data = {
			'customerId': customer_message.id,
			'status': 0 if not user_profile else user_profile[0].app_status,
			'appId': customer_message.app_id,
			'appSecret': customer_message.app_secret,
			# 'reason': customer_message.reason,
			'serverIp': customer_message.server_ip,
			'interfaceUrl': customer_message.interface_url,
			'logs': json.dumps(logs)
			# 'reviewTime': '' if not customer_message.review_time else customer_message.review_time.strftime("%Y-%m-%d")
		}

		#构造response
		response = create_response(200)
		response.data = data
		return response.get_response()
