# -*- coding: utf-8 -*-

import os
import json

from django.contrib.auth.models import User
from django.core.management.base import BaseCommand, CommandError
from django.conf import settings

from config import models as config_models


class Command(BaseCommand):
	help = "init permissions"
	args = ''
	
	def handle(self, **options):
		from django.contrib.auth.models import Permission, User
		#from django.db import connection, transaction
		manage_system_permission = Permission.objects.get(codename='__manage_system')
		manager = User.objects.get(username='manager')

		manager.user_permissions.add(manage_system_permission)
		manager.save()

		print '[success] init permissions'