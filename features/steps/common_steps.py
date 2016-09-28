# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('gb2312')

import json
import time
import shutil
import os
from datetime import datetime, timedelta
import subprocess

from behave import *
import bdd_util

from django.test.client import Client


@Given(u"{user}登录开放平台系统")
def step_impl(context, user):
	context.client = bdd_util.login(user, password=None, context=context)

@When(u"{user}登录开放平台系统")
def step_impl(context, user):
	context.client = bdd_util.login(user, password=None, context=context)

@Given(u"{user}使用密码{password}登录系统")
def step_impl(context, user, password):
	context.client = bdd_util.login(user, password=password, context=context)
