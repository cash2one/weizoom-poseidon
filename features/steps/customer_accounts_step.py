# -*- coding: utf-8 -*-
import json
import time
import logging

from django.contrib.auth.models import Group, User

from datetime import datetime, timedelta
from behave import *
import bdd_util

from account import models as account_models

@then(u"{user}查看应用列表")
def step_impl(context, user):
	context_json = table_to_list(context)
	filter_dict = {}
	user_id = User.objects.get(username=user).id
	app_status = account_models.UserProfile.objects.get(user_id=user_id).app_status
	actual_list = []
	if app_status == account_models.UNACTIVE:
		actual_list.append({
			"application_name": u'默认应用',
			"app_id": u'激活后自动生成',
			"app_secret": u'激活后自动生成',
			"status": u'未激活'
		})
	else:
		response = context.client.get('/customer/api/accounts/')
		actual = json.loads(response.content)['data']['rows']
		for rule in actual:
			if int(rule["status"]) == account_models.UNREVIEW:
				status = u'待审核'
			actual_list.append({
				"application_name": u'默认应用',
				"app_id": u'随机生成',
				"app_secret": u'随机生成',
				"status": status
			})

	bdd_util.assert_list(context_json, actual_list)

@then(u"{user}激活应用")
def step_impl(context, user):
	context.infos = json.loads(context.text)
	for info in context.infos:
		params = {
			'name': info.get('dev_name', ''),
			'mobileNumber': info.get('mobile_num', ''),
			'email': info.get('e_mail', ''),
			'interfaceUrl': info.get('ip_address', ''),
			'serverIp': info.get('interface_address', ''),
			'serverIps': '[]'
		}
		response = context.client.put('/customer/api/messages/', params)
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