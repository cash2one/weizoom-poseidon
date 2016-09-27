# -*- coding: utf-8 -*-
import json
import time
import logging

from django.contrib.auth.models import Group, User

from datetime import datetime, timedelta
from behave import *
import bdd_util

from account import models as account_models
from customer import models as customer_models

@then(u"{user}查看应用审核列表")
def step_impl(context, user):
	context_json = table_to_list(context)
	filter_dict = {}
	user_id = User.objects.get(username=user).id
	app_status = account_models.UserProfile.objects.get(user_id=user_id).app_status
	actual_list = []

	response = context.client.get('/application_audit/api/applications/')
	actual = json.loads(response.content)['data']['rows']
	for data in actual:
		status_value = data.get('status_value', '')
		appid = u'审核后自动生成'
		appsecret = u'审核后自动生成'
		if status_value == 1:
			operation = u'确认通过/驳回修改'
		if status_value == 3:
			operation = data.get('reason', '')
		if status_value == 2:
			operation = u'暂停停用'
			appid = u'随机生成'
			appsecret = u'随机生成'
		if status_value == 4:
			operation = u'启用'
			appid = u'随机生成'
			appsecret = u'随机生成'
		actual_list.append({
			"account_main": data.get('displayName', ''),
			"application_name": data.get('appName', ''),
			"appid": appid,
			"appsecret": appsecret,
			"dev_name":  data.get('DeveloperName', ''),
			"mob_number": data.get('phone', ''),
			"email_address": data.get('email', ''),
			"ip_address": data.get('serverIp', ''),
			"interface_address": data.get('interfaceUrl', ''),
			"status": data.get('status', ''),
			"operation": operation
		})
	bdd_util.assert_list(context_json, actual_list)

@When(u"{user}驳回申请")
def step_impl(context, user):
	context.infos = json.loads(context.text)
	for info in context.infos:
		account_main = info.get('account_main', '')
		user_id = User.objects.get(first_name=account_main).id
		customer_id = customer_models.CustomerMessage.objects.get(user_id=user_id).id
		params = {
			'id': customer_id,
			'reason': info.get('reason', '')
		}
		response = context.client.put('/application_audit/api/applications/', params)
		bdd_util.assert_api_call_success(response)

@When(u"{user}同意申请")
def step_impl(context, user):
	context.infos = json.loads(context.text)
	for info in context.infos:
		account_main = info.get('account_main', '')
		user_id = User.objects.get(first_name=account_main).id
		customer_id = customer_models.CustomerMessage.objects.get(user_id=user_id).id
		params = {
			'id': customer_id,
			'method': 'open'
		}
		response = context.client.post('/application_audit/api/applications/', params)
		bdd_util.assert_api_call_success(response)

@When(u"{user}暂停停用应用")
def step_impl(context, user):
	context.infos = json.loads(context.text)
	for info in context.infos:
		account_main = info.get('account_main', '')
		user_id = User.objects.get(first_name=account_main).id
		customer_id = customer_models.CustomerMessage.objects.get(user_id=user_id).id
		params = {
			'id': customer_id,
			'method': 'close'
		}
		response = context.client.post('/application_audit/api/applications/', params)
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