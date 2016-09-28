# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta
from account import models as account_models
from behave import *
import bdd_util
from eaglet.utils.resource_client import Resource


@Then(u"{user}获取'{product_id}'的商品详情")
def step_impl(context, user, product_id):
	user_id = bdd_util.get_user_id_for(user)
	param_data = {'woid':user_id, 'product_id': product_id}
	resp = Resource.use('openapi').get({
		'resource':'mall.product',
		'data':param_data
	})
	data = []
	if resp and resp['code'] == 200:
		data = resp['data']
	print  "========================================", repr(data['data']['items'])
	expected = json.loads(context.text)

	bdd_util.assert_list(expected, data['data']['items'])

@When(u"{user}调用'商品列表'api")
def step_impl(context, user):
	user_id = bdd_util.get_user_id_for(user)
	response = context.client.get('/mall/products/', {'woid': user_id})
	print  "========================================", repr(response.content)
	context["actual_product_list"] = json.loads(response.content)['data']['items']


@Then(u"{user}获取'商品列表'api返回结果")
def step_impl(context, user, product_id):
	expected = json.loads(context.text)
	bdd_util.assert_list(expected, context["actual_product_list"])