# -*- coding: utf-8 -*-
# 
from core import resource
from django.http import HttpResponse
from django.conf import settings

from core.jsonresponse import create_response
from eaglet.utils.resource_client import Resource

from account.models import AccessToken
COUNT_PER_PAGE = 20


class OrderTest(resource.Resource):
	"""
	订单url test
	"""
	app = 'mall'
	resource = 'test'
	def get(request):
		return HttpResponse('<p>HelloKitty!</p>')


class OrderList(resource.Resource):
	app = 'mall'
	resource = 'order_list'

	def get(request):
		response = create_response(200)
		


		access_token = request.GET.get('access_token',None)
		data = {}
		try:
			# print "11111",access_token
			access_token = AccessToken.objects.get(access_token=access_token)
			# print 'access_token>>>>>>>',access_token
			woid = access_token.get_woid_by_access_token
		except:
			data = { 
				'success': False,
				'errMsg': u'access_token存在问题',
				'items':[],
			}
			response.data = data
			return response.get_response()
		cur_page = request.GET.get('cur_page',1)
		count_per_page = request.GET.get('count_per_page',COUNT_PER_PAGE)
		order_status = request.GET.get('order_status', None)
		date_interval_type = request.GET.get('date_interval_type', '1') # 1下单时间 2付款时间
		start_time = request.GET.get('start_time', '')
		end_time = request.GET.get('end_time', '')
		pay_begin_time = request.GET.get('pay_begin_time','')
		pay_end_time = request.GET.get('pay_end_time','')
		order_id = request.GET.get('order_id','')
		param_data = {}
		param_data['owner_id'] = woid
		param_data['cur_page'] = cur_page
		param_data['count_per_page'] = count_per_page
		if date_interval_type.isdigit():
			if int(date_interval_type) == 1:
				if start_time and end_time:
					param_data['date_interval_type'] = 1
					param_data['date_interval'] = '{}|{}'.format(start_time, end_time)
			if int(date_interval_type) == 2:
				if pay_begin_time and pay_end_time:
					param_data['date_interval_type'] = 2
					param_data['date_interval'] = '{}|{}'.format(pay_begin_time, pay_end_time)
		if order_status:
			param_data['status'] = order_status
		if order_id:
			param_data['param_data'] = param_data
		resp = Resource.use('zeus').get({
			'resource': 'mall.order_list',
			'data': param_data
		})
		if resp:
			code = resp["code"]
			if code == 200:
				get_order_review_json = resp["data"]['orders']

				data = { 
				'success': True,
				'errMsg': '',
				'items':get_order_review_json,
				} 
				
		if not data:
			data = { 
				'success': False,
				'errMsg': '',
				'items': [],
				} 
		response.data = data
		return response.get_response()
