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

def get_access_token(user, woid):
	user_id = User.objects.get(username=user).id
	account_models.UserProfile.objects.filter(user_id=user_id).update(woid=woid)
	# user_profile = account_models.UserProfile.objects.get(user_id=user_id).woid
	#
	apps = account_models.App.objects.all()
	app = apps[apps.count()-1]
	account_models.App.objects.filter(id=app.id).update(woid=woid)

	data = {'appid': app.appid, 'secret': app.app_secret}
	resp = Resource.use('openapi').get({
		'resource': 'auth.access_token',
		'data': data
		})
	access_token = ''
	if resp:
		code = resp['code']
		if code == 200:
			access_token = resp['data']['access_token']
	assert access_token != ''
	return access_token

def get_woid(username):

	data = {'username':username}

	resp = Resource.use('weapp').get({
		'resource': 'openapi.auth_user',
		'data': data
		})
	woid = 0

	if resp:
		print resp
		code = resp['code']
		if code == 200:
			woid = resp['data']['woid']

	assert woid != 0
	return woid

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
	# if not hasattr(context, 'woid'):
	# 	context.woid = get_woid(username=account)
	# if not hasattr(context, 'access_token'):
	# 	context.access_token = get_access_token(user, context.woid)

	info = json.loads(context.text)
	ship_address = info['ship_area'] + info['ship_address']
	products = []
	print "?"*100
	print "context.product_name2id",context.product_name2id
	for item in info['group']:
		for product_item in item['products']:
			tmp_product = {}
			tmp_product['product_count'] = product_item['count']
			# if product_item['name'] == u'商品1':
				
			tmp_product['product_id'] = context.product_name2id[product_item['name']]
			print 'id', context.product_name2id[product_item['name']]
			tmp_product['product_model_name'] = 'standard'

			products.append(tmp_product)
	products = json.dumps(products)
	data = {
		'woid': context.woid,
		'apiserver_access_token': context.apiserver_access_token,
		'access_token': context.openapi_access_token,
		# 'order_id': info['order_no'],
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
	print "*"*100
	print 'resp',resp

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
	# if not hasattr(context, 'woid'):
	# 	context.woid = get_woid(username=account)
	# if not hasattr(context, 'access_token'):
	# 	context.access_token = get_access_token(user, context.woid)
	data['woid'] = context.woid
	data['access_token'] = context.openapi_access_token
	data['apiserver_access_token'] = context.apiserver_access_token,
	actual_list = []
	expected_list = []
	print ">>"*100

	expected_orders = json.loads(context.text)
	# print 'expected_orders',expected_orders
	for expected_order in expected_orders:
		# print ">>"*100
		print 'expected_order',expected_order
		order = {}
		order['final_price'] = float(expected_order['final_price'])
		order['order_status'] = ORDER_STATUS2ID[expected_order['status']]
		order['product_count'] = expected_order['products_count']
		order['products'] = []
		# print "<<"*100
		for supplier_group in expected_order['group']:
			# print "supplier_group",supplier_group
			for product in supplier_group['products']:
				
				print 'product',product
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


	print "*111"*100, resp
	print resp['data']['orders']
	print len(resp['data']['orders'])

	print "expected_list",expected_list
	print "actual_list",actual_list
	bdd_util.assert_list(expected_list, actual_list)


# Then jd获取'订单详情'api返回结果
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
	print "*"*100
	print 'resp',resp
	# expected_order = {}
	if resp:
		code = resp['code']
		if code == 200:
			actual_order = resp['data']['order']

	expected = json.loads(context.text)
	ship_address = expected['ship_area'] + expected['ship_address']
	# ORDER_STATUS2ID[expected_order['status']]
	expected_order = {
		'order_status': ORDER_STATUS2ID[expected['status']],
		'ship_address': ship_address,
		'ship_name': expected['ship_name'],
		'ship_tel': expected['ship_tel'],
		'sub_orders': []
	}
	# if expected_order['order_status'] != 0:
	for sub_order in expected['group']:
		tmp_order = {
			'postage': sub_order['postage'],
			'order_status': ORDER_STATUS2ID[sub_order['status']],
			# 'order_id': sub_orders['order_id'],
			'products': []
		}
		for product in sub_order['products']:
			tmp_order['products'].append({
				'product_name': product['name'],
				'price': product['price'],
				'product_count': product['count'],
				})
		expected_order['sub_orders'].append(tmp_order)
	# if expected_order['order_status'] == u'待支付':
	# 	expected_order['sub_orders'] = []
	print ">>>>*"*100
	print 'expected_order',expected_order
	print 'actual_order',actual_order
	bdd_util.assert_dict(expected_order, actual_order)
