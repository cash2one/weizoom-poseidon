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

UNACTIVE = 0
UNREVIEW = 1
USING = 2
APP_STATUS = (
	(UNACTIVE, u'未激活'),
	(UNREVIEW, u'待审核'),
	(USING, u'已启用')
)
APP_STATUS2NAME = dict(APP_STATUS)

class UserProfile(models.Model):
	user = models.ForeignKey(User, unique=True)
	manager_id = models.IntegerField(default=0) #创建该用户的系统用户的id
	app_status = models.IntegerField(default=UNACTIVE,choices=APP_STATUS)  #应用状态
	status = models.IntegerField(default=1) #账号状态 1开启 0关闭

	class Meta(object):
		db_table = 'account_user_profile'
		verbose_name = '用户配置'
		verbose_name_plural = '用户配置'

	@property
	def is_manager(self):
		return (self.user_id == self.manager_id) or (self.manager_id == 2) #2 is manager's id


def create_profile(instance, created, **kwargs):
	"""
	自动创建user profile
	"""
	if created:
		if instance.username == 'admin':
			return
		if UserProfile.objects.filter(user=instance).count() == 0:
			profile = UserProfile.objects.create(user = instance)
			

signals.post_save.connect(create_profile, sender=User, dispatch_uid = "account.create_profile")

class App(models.Model):
	"""
	
	"""
	appid = models.CharField(max_length=30)
	app_secret = models.CharField(max_length=100)
	woid = models.CharField(max_length=100)
	is_active = models.BooleanField(default=False)
	#TODO copid
	name = models.CharField(max_length=100)
	created_at = models.DateTimeField(default=datetime.datetime.now)

	class Meta:
		db_table = 'app'
		verbose_name = 'App'
		verbose_name_plural = 'App'


class AccessToken(models.Model):
	app = models.ForeignKey(App)
	access_token = models.CharField(max_length=256)
	expires_in = models.CharField(max_length=100, verbose_name='expires_in')
	is_active = models.BooleanField(default=True, verbose_name='at是否有效')
	created_at = models.DateTimeField(auto_now_add=True)

	class Meta:
		db_table = 'access_token'
		verbose_name = 'access_token'
		verbose_name_plural = 'access_token'
