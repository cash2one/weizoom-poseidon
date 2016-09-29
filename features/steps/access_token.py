# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta
from collections import OrderedDict
from account.models import App, AccessToken
from eaglet.utils.resource_client import Resource

from behave import *
import bdd_util
from django.contrib.auth import models as auth_models

__author__ = 'bert'

@When(u"{user}获取access_token")
def step_impl(context, user):
	woid = context.woid
	
	app_id = context.app_id
	app_secret = context.app_secret

	params = {
		'woid': woid
	}
	
	resp = Resource.use("apiserver").put(
		{
			'resource': 'user.token',
			'data': params
		}
	)
	if resp and resp.get('code') == 200:
		apiserver_access_token = resp.get('data').get('access_token')
		logging.info("apiserver_access_token : %s"% apiserver_access_token)
		context.apiserver_access_token = apiserver_access_token
		
		app = App.objects.get(woid=woid)
		app.apiserver_access_token = apiserver_access_token
		app.save()

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
	if resp and resp.get('code') == 200:
		openapi_access_token = resp.get('data').get('access_token')
		logging.info("openapi_access_token : %s"% openapi_access_token)
		context.openapi_access_token = openapi_access_token


