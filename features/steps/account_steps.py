# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta

from behave import *
import bdd_util

from outline import models as outline_models

__author__ = 'kuki'

def __get_status(type):
	if type:
		type2type_dic = {u"是":1,u"否":0}
		return type2type_dic[type]
	else:
		return 1

@when(u"{user}创建开放平台账号")
def step_impl(context, user):
	infos = json.loads(context.text)
	for info in infos:
		params = {
			'name': info.get('account_name', ''),
			'password': info.get('password', ''),
			'display_name': info.get('account_main', ''),
			'status': __get_status(info.get('isopen', ''))
		}
		print params
		response = context.client.put('/config/api/user/', params)
		bdd_util.assert_api_call_success(response)


# @when(u"{user}删除商品'{product_name}'")
# def step_impl(context, user, product_name):
# 	user_id = bdd_util.get_user_id_for(user)
# 	product = outline_models.Product.objects.get(owner_id=user_id, name=product_name)

# 	response = context.client.delete('/outline/api/data/', {'id': product.id})
# 	bdd_util.assert_api_call_success(response)


# @then(u"{user}能获得商品列表")
# def step_impl(context, user):
# 	expected = json.loads(context.text)

# 	response = context.client.get('/outline/api/datas/')
# 	actual = json.loads(response.content)['data']['rows']
# 	logging.info(actual)
	
# 	bdd_util.assert_list(expected, actual)