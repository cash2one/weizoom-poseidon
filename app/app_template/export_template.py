# -*- coding: utf-8 -*-
{% for resource in resources %}
{% if resource.need_export %}
import {{resource.lower_name}}
{% endif %}
{% endfor %}
__STRIPPER_TAG__
__STRIPPER_TAG__
NAV = {
{% for resource in resources %}
{% if resource.is_main_entry %}
	'name': "{{resource.lower_name}}",
	'displayName': "{{resource.display_name}}",
	'href': '/app/{{app_name}}/{{resource.plural_name}}/',
	'need_permissions': []
{% endif %}
{% endfor %}
}


__STRIPPER_TAG__
__STRIPPER_TAG__
def get_link_targets(request):
	{% for resource in resources %}
	{% if resource.need_export %}
	pageinfo, datas = {{resource.lower_name}}.{{resource.class_name}}.get_datas(request)
	link_targets = []
	for data in datas:
		link_targets.append({
			"id": str(data.id),
			"name": data.name,
			"link": '/app/{{app_name}}/m_{{resource.item_lower_name}}/?webapp_owner_id=%d&id=%s' % (request.manager.id, data.id),
			"isChecked": False,
			"created_at": data.created_at.strftime("%Y-%m-%d %H:%M:%S")
		})
	{% endif %}
	{% endfor %}

	return pageinfo, link_targets