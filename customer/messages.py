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
from core.frontend_data import FrontEndData

FIRST_NAV = 'customer'
SECOND_NAV = 'customer-accounts'


class Messages(resource.Resource):
	app = 'customer'
	resource = 'messages'

	@login_required
	def get(request):
		"""
		用户提交信息页面
		"""
		customer_id = request.GET.get('customer_id',-1)
		print customer_id,"============"
		frontend_data = FrontEndData()
		if customer_id !=-1 :
			customer_message = models.CustomerMessage.objects.get(user=request.user, id=customer_id)
			customer_data = {
				'id': customer_message.id,
				'name': customer_message.name,
				'mobileNumber': customer_message.mobile_number,
				'email': customer_message.email,
				'serverIp': customer_message.server_ip,
				'interfaceUrl': customer_message.interface_url,
				'serverIps': [] #更多服务器ip
			}
	
			#获取商品规格
			customer_server_ips = models.CustomerServerIps.objects.filter(customer_id=customer_message)
			for server_ip in customer_server_ips:
				customer_data['serverIps'].append({
					'ipName': server_ip.name
				})

			frontend_data.add('customer',customer_data)
		else:
			frontend_data.add('customer', None)
		c = RequestContext(request, {
			'first_nav_name': FIRST_NAV,
			'second_navs': nav.get_second_navs(),
			'second_nav_name': SECOND_NAV,
			'frontend_data': frontend_data
		})
		
		return render_to_response('customer/messages.html', c)

	@login_required
	def api_put(request):
		"""
		保存提交信息
		"""
		customer_message = models.CustomerMessage.objects.create(
			user = request.user, 
			name = request.POST['name'], 
			mobile_number = request.POST['mobileNumber'], 
			email = request.POST['email'],
			interface_url = request.POST['interfaceUrl'],
			server_ip = request.POST['serverIp'],
			status = models.STATUS_CHECKING
		)

		server_ips = json.loads(request.POST['serverIps'])
		for server_ip in server_ips:
			models.CustomerServerIps.objects.create(customer=customer_message, name=server_ip['ipName'])

		response = create_response(200)
		return response.get_response()

	@login_required
	def api_post(request):
		"""
		更新信息
		"""
		customer_id=request.POST['id']
		models.CustomerMessage.objects.filter(user=request.user, id=request.POST['id']).update(
			user = request.user, 
			name = request.POST['name'], 
			mobile_number = request.POST['mobileNumber'], 
			email = request.POST['email'],
			interface_url = request.POST['interfaceUrl'],
			server_ip = request.POST['serverIp'],
			status = models.STATUS_CHECKING
		)

		#删除、重建商品文档
		server_ips = json.loads(request.POST['serverIps'])
		models.CustomerServerIps.objects.filter(customer_id=customer_id).delete()
		for server_ip in server_ips:
			models.CustomerServerIps.objects.create(customer_id=customer_id, name=server_ip['ipName'])

		response = create_response(200)
		return response.get_response()