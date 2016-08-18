# -*- coding: utf-8 -*-
# 
from core import resource
from django.http import HttpResponse
from django.conf import settings

from core.jsonresponse import create_response
from eaglet.utils.resource_client import Resource

from account.models import AccessToken
COUNT_PER_PAGE = 10


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
			access_token = AccessToken.objects.get(access_token=access_token)
			woid = access_token.get_woid_by_access_token
		except:
			errMsg = u'access_token存在问题'
		cur_page = request.GET.get('cur_page',1)
		count_per_page = request.GET.get('count_per_page',COUNT_PER_PAGE)
		order_status = request.GET.get('order_status', None)
		date_interval_type = request.GET.get('date_interval_type', '1') # 1下单时间 2付款时间
		start_time = request.GET.get('start_time', '')
		end_time = request.GET.get('end_time', '')
		pay_begin_time = request.GET.get('pay_begin_time','')
		pay_end_time = request.GET.get('pay_end_time','')
		order_id = request.GET.get('order_id','') #订单号，zeus暂不支持
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
			param_data['param_data'] = order_id

		items = []
		resp = Resource.use('zeus').get({
			'resource': 'mall.order_list',
			'data': param_data
		})
		if resp:
			code = resp["code"]
			if code == 200:
				orders = resp["data"]['orders']

				items = []

				for order in orders:
					item = {}
					item['order_id'] = order['order_id']
					item['order_status'] = order['order_status']
					item['order_price'] = order['final_price']
					item['created_at'] = order['created_at']
					item['pay_time'] = order['pay_time']
					item['remark'] = order['remark']
					item['pay_mode'] = order['pay_interface_name']
					item['express_info'] = {}
					item['express_info']['ship_name'] = order["ship_name"]
					item['express_info']['ship_tel'] = order["ship_tel"]
					item['express_info']['ship_address'] = order["ship_area"]+' '+order["ship_address"] if order["ship_area"] else order["ship_area"]
					item['express_info']['express_number'] = order['express_number']
					item['express_info']['express'] = order['express_company_name']
					item['express_info']['customer_message'] = order['customer_message']
					item['bill_type'] = order['bill_type']
					item['bill'] = order['bill']

					item['products'] = []
					for group in order['groups']:
						
						for product in group['products']:
							product_info = {}
							product_info['count'] = product['count']
							product_info['total_price'] = product['total_price']
							product_info['name'] = product['name']
							product_info['weight'] = product['weight']
							# product_info['grade_discounted_money'] = product['grade_discounted_money']
							product_info['price'] = product['price']
							product_info['user_code'] = product['user_code']
							product_info['thumbnails_url'] = product['thumbnails_url']
							product_info['physical_unit'] = product['physical_unit']
							# product_info['purchase_price'] = product['purchase_price']
							if product['product_model_name'] == "standard":
								product_info['model_name'] = ''
							else:
								model_names = []
								for product_model_name in product['custom_model_properties']:
									model_names.append(product_model_name['property_value'])
									product_info['model_name'] = ' '.join(model_names)
							# item['products'].append(group['products'])
							item['products'].append(product_info)
					items.append(item)

				#添加页面信息
				resp_pageinfo = resp["data"]['pageinfo']
				pageinfo = {}
				pageinfo['max_page'] = resp_pageinfo['max_page']
				pageinfo['cur_page'] = resp_pageinfo['cur_page']
				pageinfo['order_count'] = resp_pageinfo['object_count']
				errMsg = ''
			else:
				errMsg = u'服务器出现问题，请联系管理员'
		else:
			errMsg = u'请求存在问题，请联系管理员'
 
		if errMsg:
			response = create_response(500)
			response.errMsg = errMsg
			return response.get_response()
		else:
			response = create_response(200)
			response.data = {'pageinfo': pageinfo, 'orders':items}
			return response.get_response()
