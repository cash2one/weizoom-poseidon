# -*- coding: utf-8 -*-
__author__ = 'robert'

SECOND_NAVS = [{
	'name': 'config-user',
	'displayName': '用户管理',
	'href': '/config/users/'
}, {
	'name': 'config-permission',
	'displayName': '权限管理',
	'href': '/config/permissions/'
}]

def get_second_navs():
	return SECOND_NAVS