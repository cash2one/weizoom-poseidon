# -*- coding: utf-8 -*-

from django.conf import settings

#===============================================================================
# top_navs : 获得top nav集合
#===============================================================================
def top_navs(request):
	top_navs = [{
		'name': 'outline',
		'displayName': '数据概况',
		'icon': 'list-alt',
		'href': '/outline/datas/'
	}, {
		'name': 'app',
		'displayName': '运营活动',
		'icon': 'fa-html5',
		'href': '/app/apps/'
	}]

	if request.user.has_perm('permission.__manage_system'):
		top_navs = [{
			'name': 'config',
			'displayName': '账号管理',
			'icon': 'cog',
			'href': '/config/users/'
		}]
		
	return {'top_navs': top_navs}


def webpack_bundle_js(request):
	return {
		'webpack_bundle_js': settings.WEBPACK_BUNDLE_JS
	}