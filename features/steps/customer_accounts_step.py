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
	expected = json.loads(context.text)
	filter_dict = {}
	response = context.client.get('/customer/api/accounts/')
	actual = json.loads(response.content)['data']['data']
	rule_list = []
	for rule in actual:
		rule_list.append({
			"name": rule["name"],
			"money": rule["money"],
			"num": str(rule["count"]),
			"stock": str(rule["storage_count"]),
			"type": rule["card_kind"],
			"card_range": rule["card_range"],
			"comments": rule['remark'],
			"card_level": rule['card_level']
		})


	bdd_util.assert_list(expected, rule_list)
