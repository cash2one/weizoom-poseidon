# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta

from behave import *
import bdd_util

@Then(u"{user}获取'{product_id}'的商品详情")
def step_impl(context, user, product_id):
	user_id = bdd_util.get_user_id_for(user)
	response = context.client.get('/mall/product/', {'product_id': product_id})
	print  "========================================", repr(response.content)
	actual_product = json.loads(response.content)['data']['items']

    expected = json.loads(context.text)

    bdd_util.assert_list(expected, actual_product)

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