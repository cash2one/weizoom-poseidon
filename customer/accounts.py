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
from resource import models as resource_models
from util import string_util

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
		customer_message = models.CustomerMessage.objects.filter(user=request.user)
		status = 0 if not customer_message else customer_message[0].status
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
		data = {
			'customerId': customer_message.id,
			'status': customer_message.status,
			'appId': customer_message.app_id,
			'appSecret': customer_message.app_secret,
			'reason': customer_message.reason,
			'serverIp': customer_message.server_ip,
			'interfaceUrl': customer_message.interface_url,
			'reviewTime': '' if not customer_message.review_time else customer_message.review_time.strftime("%Y-%m-%d")
		}

		#构造response
		response = create_response(200)
		response.data = data
		return response.get_response()
