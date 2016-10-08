# -*- coding: utf-8 -*-
import json
import time
import logging
import requests
from django.contrib.auth.models import Group, User

from datetime import datetime, timedelta
from behave import *
import bdd_util

from account import models as account_models
from eaglet.utils.resource_client import Resource

ORDER_STATUS2ID = {
    u'全部': -1,
    u'待支付': 0,
    u'已取消': 1,
    u'待发货': 3,
    u'已发货': 4,
    u'已完成': 5,
    u'退款中': 6,
    u'退款成功': 7
}

@Given(u"自营平台'{account}'已获取{user}订单")
def step_impl(context, user, account):
	info = json.loads(context.text)
	ship_address = info['ship_area'] + info['ship_address']
	products = []
	for item in info['group']:
		for product_item in item['products']:
			tmp_product = {}
			tmp_product['product_count'] = product_item['count']
			tmp_product['product_id'] = context.product_name2id[product_item['name']]
			tmp_product['product_model_name'] = 'standard'

			products.append(tmp_product)
	products = json.dumps(products)
	data = {
		'woid': context.woid,
		'apiserver_access_token': context.apiserver_access_token,
		'access_token': context.openapi_access_token,
		'deal_id': info['deal_id'],
		'ship_name': info['ship_name'],
		'ship_tel': info['ship_tel'],
		'ship_address': ship_address,
		'products': products
	}
	
	resp = Resource.use('openapi').put({
		"resource": "mall.order",
		"data":data
		})

	if resp:
		if resp['code'] == 200:
			context.order_id = resp['data']['order_id']


@When(u"{user}调用'订单列表'api")
def step_impl(context, user):
	
	count_per_page = json.loads(context.text)['count_per_page']
	cur_page = json.loads(context.text)['cur_page']
	context.count_per_page = count_per_page
	context.cur_page = cur_page

@Then(u"{user}获取'订单列表'api返回结果")
def step_impl(context, user):
	
	data = {}
	if not (hasattr('context', 'count_per_page') and hasattr('context', 'cur_page')):
		data['count_per_page'] = context.count_per_page
		data['cur_page'] = context.cur_page
		del context.count_per_page
		del context.cur_page
	data['woid'] = context.woid
	data['access_token'] = context.openapi_access_token
	data['apiserver_access_token'] = context.apiserver_access_token,
	actual_list = []
	expected_list = []

	expected_orders = json.loads(context.text)
	for expected_order in expected_orders:
		order = {}
		order['final_price'] = float(expected_order['final_price'])
		order['order_status'] = ORDER_STATUS2ID[expected_order['status']]
		order['product_count'] = expected_order['products_count']
		order['products'] = []
		for supplier_group in expected_order['group']:
			for product in supplier_group['products']:
				order['products'].append({
					'price': product['price'],
					'product_name': product['name'],
					'product_count': product['count']
					})
		expected_list.append(order)

	resp = Resource.use('openapi').get({
		'resource': 'mall.order_list',
		'data': data
		})

	if resp:
		code = resp['code']
		if code == 200:
			actual_list = resp['data']['orders']

	bdd_util.assert_list(expected_list, actual_list)


@When(u"{user}调用'订单详情'api")
def step_impl(context, user):
	
	order_id = json.loads(context.text)['order_no']
	context.order_id = order_id


@Given(u"{user}订单已支付")
def step_impl(context, user):
	order_id = json.loads(context.text)['order_no']
	data = {
		'order_id': order_id,
		'access_token': context.openapi_access_token,
		'woid': context.woid,
		'apiserver_access_token': context.apiserver_access_token
	}
	resp = Resource.use('openapi').put({
		'resource': 'pay.third_pay',
		'data': data
		})
	if resp:
		assert 200==resp['code']


@Then(u"{user}获取'订单详情'api返回结果")
def step_impl(context, user):
	data = {}
	data['woid'] = context.woid
	data['access_token'] = context.openapi_access_token
	data['apiserver_access_token'] = context.apiserver_access_token,
	if hasattr(context, 'order_id'):
		order_id = context.order_id
		del context.order_id

	# order_id ='001'
	data['order_id'] = order_id

	resp = Resource.use('openapi').get({
		'resource': 'mall.order',
		'data': data
		})
	actual_order = {}
	if resp:
		code = resp['code']
		if code == 200:
			actual_order = resp['data']['order']

	expected = json.loads(context.text)
	ship_address = expected['ship_area'] + expected['ship_address']
	expected_order = {
		'order_status': ORDER_STATUS2ID[expected['status']],
		'ship_address': ship_address,
		'ship_name': expected['ship_name'],
		'ship_tel': expected['ship_tel'],
		'postage': expected['postage'],
		'final_price': expected['final_price'],
		'sub_orders': []
	}
	if expected_order['order_status'] != 0 and actual_order['sub_orders']:
		for sub_order in expected['group']:
			tmp_order = {
				'postage': sub_order['postage'],
				'order_status': ORDER_STATUS2ID[sub_order['status']],
				'products': []
			}
			for product in sub_order['products']:
				tmp_order['products'].append({
					'product_name': product['name'],
					'price': product['price'],
					'product_count': product['count'],
					})
			expected_order['sub_orders'].append(tmp_order)
	else:
		products = []
		for product in expected['products']:
			products.append({
				'product_name': product['name'],
				'price': product['price'],
				'product_count': product['count']
				})
		expected_order['products'] = products

	bdd_util.assert_dict(expected_order, actual_order)
