# -*- coding: utf-8 -*-

__STRIPPER_TAG__
NAV = [
	{
		'name': "name",
		'displayName': u"{{app_display_name}}",
		'href': 'javascript:void(0);',
		'need_permissions': [],
		'extraClass': 'xui-app-name',
		'isNotLink': True
	},
	{
		'name': "apps",
		'displayName': u"返回",
		'href': '/app/apps/',
		'need_permissions': [],
		'icon': 'arrow-left'
	},
	{% for resource in resources %}
	{% if resource.need_export %}
	{
		'name': "{{resource.lower_name}}",
		'displayName': u"{{resource.display_name}}",
		'href': '/app/{{app_name}}/{{resource.lower_name}}/',
		'need_permissions': []
	},
	{% endif %}
	{% endfor %}
]


__STRIPPER_TAG__
__STRIPPER_TAG__
########################################################################
# get_second_navs: 获得二级导航
########################################################################
def get_second_navs(request):
	return NAV
__STRIPPER_TAG__