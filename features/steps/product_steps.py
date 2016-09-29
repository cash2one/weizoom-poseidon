# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta
from account import models as account_models
from behave import *
import bdd_util
from eaglet.utils.resource_client import Resource


@Then(u"{user}获取'{product_name}'的商品详情")
def step_impl(context, user, product_name):
	param_data = {'woid':context.woid,"access_token":context.openapi_access_token}
	
	resp = Resource.use('openapi').get({
		'resource':'mall.products',
		'data':param_data
	})
	data = []
	product_id = None
	if resp and resp['code'] == 200:
		data = resp['data']
		data = data['data']['items']
		for product in data:
			if product['name'] == product_name:
				product_id= product['id']
				break
	if product_id:
		param_data = {'woid':context.woid, 'product_id': product_id,"access_token":context.openapi_access_token}
		resp = Resource.use('openapi').get({
			'resource':'mall.product',
			'data':param_data
		})
		data = []
		if resp and resp['code'] == 200:
			data = resp['data']

			data = data['data']['items']
			actual_product = {}
			actual_product['name'] = data['name']
			actual_product['price'] = float(data['price_info']['display_price'])
			actual_product['weight'] = float(data['models'][0]['weight'])
			actual_product['image'] = data['thumbnails_url'].replace(' ','')
			actual_product['stocks'] = float(data['total_stocks'])
			actual_product['detail'] = data['detail'][15:-18]
			actual_product['postage'] = [{'postage':float(data['supplier_postage_config']['postage']),'condition_money':float(data['supplier_postage_config']['condition_money'])}]
			if not hasattr(context, 'products'):
				context.product_name2id = {}
			context.product_name2id[data['name']] = product_id
			expected = json.loads(context.text)

			bdd_util.assert_dict(expected, actual_product)
	else:
		1/0

@When(u"{user}调用商品列表")
def step_impl(context, user):
	param_data = {'woid':context.woid,"access_token":context.openapi_access_token}
	
	resp = Resource.use('openapi').get({
		'resource':'mall.products',
		'data':param_data
	})
	data = []
	if resp and resp['code'] == 200:
		data = resp['data']
		logging.info(">>>>>>>>!")
		logging.info(data)
		logging.info(">>>>>>>#####")
		data = data['data']['items']
		for product in data:
			product['price'] = float(product['display_price'])
			product['image'] = product['thumbnails_url']
			product['sales'] = product['sales']
			del product['display_price']
		context.actual_product_list = data
	else:
		1/0


@Then(u"{user}获取商品列表返回结果")
def step_impl(context, user):
	expected = json.loads(context.text)
	bdd_util.assert_list(expected, context.actual_product_list )