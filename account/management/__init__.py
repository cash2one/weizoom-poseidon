# -*- coding: utf-8 -*-
from django.db.models import get_models, signals
from django.contrib.auth.models import User

from account import models as account_models

#===============================================================================
# init_poseidon : 初始化role与group
#===============================================================================
def init_poseidon(app, created_models, verbosity, **kwargs):
	from django.contrib.auth.models import Permission
	from django.contrib.auth.models import Group
	from django.contrib.contenttypes.models import ContentType
	
	#如果group_count大于1，意味着已经创建过role和group了，不用再次创建
	group_count = Group.objects.count()
	if group_count >= 1:
		return

	#创建content type
	ctype = ContentType.objects.create(
		name = u'MANAGE_SYSTEM',
		app_label = 'permission',
		model = 'permission'
	)
	
	#管理员组
	g = Group.objects.create(name="SystemManager")
	manage_system_permission = Permission.objects.create(name="Can manage system", codename="__manage_system", content_type=ctype)
	g.permissions.add(manage_system_permission)
	#普通成员组
	g = Group.objects.create(name="Staff")
	manage_basic_action_permission = Permission.objects.create(name="Can do basic action", codename="__manage_basic_action", content_type=ctype)
	g.permissions.add(manage_basic_action_permission)

	print "Install custom permission groups for poseidon successfully"


signals.post_syncdb.connect(init_poseidon, sender=account_models, dispatch_uid = "poseidon.init_poseidon")
	