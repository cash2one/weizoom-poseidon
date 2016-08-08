# -*- coding: utf-8 -*-
# 
from core import resource
from django.http import HttpResponse
from django.conf import settings

from core.jsonresponse import create_response
from eaglet.utils.resource_client import Resource

from account.models import AccessToken



class OrderShip(resource.Resource):
	app = 'mall'
	resource = 'order_ship'

	def post(request):
		response = create_response(200)
		access_token = request.POST.get('access_token',None)
		data = {}
		try:
			access_token = AccessToken.objects.get(access_token=access_token)
			woid = access_token.get_woid_by_access_token
		except:
			data = { 
				'is_success': False,
				'errMsg': u'access_token存在问题',
			}
			response.data = data
			return response.get_response()

		order_id = request.POST.get('order_id','')
		express = request.POST.get('express','')
		express_number = request.POST.get('express_number','')
		operator_name = request.POST.get('operator_name','')

		if order_id and express and express_number:
			param_data = {
				'order_id': order_id,
				'express_company_name': express,
				'express_number': express_number,
				'operator_name': operator_name
			}
			resp = Resource.use('zeus').put({
			'resource': 'mall.delivery',
			'data': param_data
			})
			if resp and resp["code"]==200:
				print 'resp>>>>',resp
				success = resp['data']["result"]
				if success == 'SUCCESS':

					data = { 
					'is_success': True,
					'errMsg': '',
					}
				else:
					data = { 
					'is_success': False,
					'errMsg': resp['data']['msg'],
					}

		else:
			data = { 
				'is_success': False,
				'errMsg': u'缺少必要参数',
				} 
		if not data:
			data = { 
				'is_success': False,
				'errMsg': u'请求存在问题，请联系管理员',
				} 
		response.data = data
		return response.get_response()

