# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta
from collections import OrderedDict

from behave import *
import bdd_util
from django.contrib.auth import models as auth_models

__author__ = 'kuki'

def __get_status(type):
	if type:
		type2type_dic = {u"是":1,u"否":0}
		return type2type_dic[type]
	else:
		return 1

def __get_user_id_by_display_name(account_main):
	return auth_models.User.objects.get(first_name=account_main).id

def __get_user_id_by_username(account_name):
	return auth_models.User.objects.get(username=account_name).id

def __get_actions(status):
	"""
	根据账号状态
	返回对于操作列表
	"""
	if status == 1:
		actions_list = u"编辑/关闭"
	else:
		actions_list = u"编辑/删除"
	return actions_list

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

@when(u"{user}编辑账号'{display_name}'")
def step_impl(context, user, display_name):
	infos = json.loads(context.text)
	for info in infos:
		params = {
			'id': __get_user_id_by_display_name(display_name),
			'name': info.get('account_name', ''),
			'password': info.get('password', ''),
			'display_name': info.get('account_main', ''),
			'status': __get_status(info.get('isopen', ''))
		}
		print params
		response = context.client.post('/config/api/user/', params)
		bdd_util.assert_api_call_success(response)

@when(u"{user}关闭账号")
def step_impl(context, user):
	infos = json.loads(context.text)
	for info in infos:
		params = {
			'id': __get_user_id_by_username(info.get('account_name', ''))
		}
		print params
		response = context.client.post('/config/api/users/', params)
		bdd_util.assert_api_call_success(response)

@then(u"{user}查看账号列表")
def step_impl(context, user):
	actual = []
	response = context.client.get('/config/api/users/')
	rows = json.loads(response.content)['data']['rows']
	for row in rows:
		p_dict = OrderedDict()
		p_dict[u"account_name"] = row['username']
		p_dict[u"main_name"] = row['displayName']
		p_dict[u"create_time"] = bdd_util.__datetime2str(row['createdAt'])
		p_dict[u"status"] = row['AppStatus']
		p_dict[u"operation"] = __get_actions(row['status'])
		actual.append((p_dict))
	logging.info(actual)

	expected = []
	if context.table:
		for row in context.table:
			cur_p = row.as_dict()
			expected.append(cur_p)
	else:
		expected = json.loads(context.text)
	print("expected: {}".format(expected))

	bdd_util.assert_list(expected, actual)