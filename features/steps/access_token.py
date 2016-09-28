# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta
from collections import OrderedDict

from eaglet.utils.resource_client import Resource

from behave import *
import bdd_util
from django.contrib.auth import models as auth_models

__author__ = 'bert'

@When(u"{user}获取access_token")
def step_impl(context, user):
	app_id = context.app_id
	app_secret = context.app_secret

	params = {
			'appid': app_id,
			'secret': app_secret
	}
	resp = Resource.use("openapi").get(
		{
			'resource': 'auth.access_token',
			'data': params
		}
	)
	rows = []
	if resp and resp.get('code') == 200:
		access_token = resp.get('data').get('access_token')
		logging.info("access_token : %s"% access_token)
		context.access_token = access_token

	