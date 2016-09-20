# -*- coding: utf-8 -*-

import os
import json
from hashlib import md5
from core.dateutil import get_current_time_in_millis
import datetime

from django.contrib.auth.signals import user_logged_in
from django.db import models
from django.contrib.auth.models import Group, User
from django.db.models import signals
from django.conf import settings
from django.db.models import F

from core import dateutil

class ApplicationLog(models.Model):
	"""
	审核记录表
	"""
	user_id = models.IntegerField(default=0) #用户user_id
	customer_id = models.IntegerField(default=0) #CustomerMessage表id
	status = models.IntegerField(default=0) #改变的状态
	reason = models.CharField(max_length=1024, null=True) #驳回原因
	review_time = models.DateTimeField(auto_now_add=True)  #添加时间

	class Meta(object):
		db_table = 'application_log'