# -*- coding: utf-8 -*-
__author__ = 'robert'

FIRST_NAV = 'app'

SECOND_NAVS = [{
	"name": 'outline',
	"displayName": u'运营概况',
	"href": '/app/apps/'
}]

def add_second_nav(nav):
	SECOND_NAVS.append(nav)

def get_second_navs():
	return SECOND_NAVS