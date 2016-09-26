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
	#items = json.loads(response.content)['data']['items']

    # actual_orders = __get_order_items_for_self_order(items)

    # expected = json.loads(context.text)
    # for order in expected:
    #     if 'actions' in order:
    #         order['actions'] = set(order['actions'])  # 暂时不验证顺序

    # bdd_util.assert_list(expected, actual_orders)