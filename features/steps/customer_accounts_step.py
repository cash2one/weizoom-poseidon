# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta

from behave import *
import bdd_util

from outline import models as outline_models

@then(u"{user}查看应用列表")
def step_impl(context, user):
	context_json = table_to_list(context)
	filter_dict = {}
	response = context.client.get('/customer/api/accounts/')
	actual = json.loads(response.content)['data']['data']
	actual_list = []
	for rule in actual:
		actual_list.append({
			"application_name": u'默认应用',
			"app_id": rule["appId"],
			"app_secret": str(rule["appSecret"]),
			"status": str(rule["status"])
		})

	bdd_util.assert_list(context_json, actual_list)

@then(u"{user}激活应用")
def step_impl(context, user):
	context.infos = json.loads(context.text)
	for info in context.infos:
		customer_info = {
			'name': order_info.get('dev_name', ''),
			'mobileNumber': order_info.get('mobile_num', ''),
			'email': order_info.get('e_mail', ''),
			'interfaceUrl': order_info.get('ip_address', ''),
			'serverIp': order_info.get('interface_address', '')
		}
	response = context.client.put('/customer/api/messages/', customer_info)
	bdd_util.assert_api_call_success(response)

def table_to_list(context):
	""" 
	将表格形式的数据转成可以比较的数据
	"""
	expected_table = context.table
	expected_list = []
	if expected_table:
		for row in expected_table:
			data = row.as_dict()
			expected_list.append(data)
	return expected_list