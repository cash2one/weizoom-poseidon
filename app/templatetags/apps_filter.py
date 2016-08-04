# -*- coding:utf-8 -*-

import time
import os
import json
from datetime import timedelta, datetime, date

from django import template
from django.core.cache import cache
from django.contrib.auth.models import User
from django.conf import settings
from django.db.models import Q

from utils import resource_util

register = template.Library()


@register.filter(name='is_system_manager')
def is_system_manager(user):
	if user is None:
		return False
	else:
		return user.username == 'manager'


@register.filter(name='load_views')
def load_views(args):
	items = ["<!-- start views -->"]
	for view in resource_util.get_web_views():
		items.append('\n\n<!-- view template from %s -->\n' % view['template_file_path'])
		items.append(view['template_source'])
		items.append('<!-- view js from %s -->\n' % view['js_file_path'])
		items.append('<script type="text/javascript">')
		items.append(view['js_source'])
		items.append('</script>')
	items.append('<!-- finish views -->')

	return '\n'.join(items)


@register.filter(name='load_dialogs')
def load_dialogs(args):
	items = ["<!-- start dialogs -->"]
	for view in resource_util.get_web_dialogs():
		items.append('\n\n<!-- dialog template from %s -->\n' % view['template_file_path'])
		items.append(view['template_source'])
		items.append('<!-- dialog js from %s -->\n' % view['js_file_path'])
		items.append('<script type="text/javascript">')
		items.append(view['js_source'])
		items.append('</script>')
	items.append('<!-- finish dialogs -->')

	return '\n'.join(items)


@register.filter(name='load_app_views_and_dialogs')
def load_app_views_and_dialogs(app):
	app_dir = os.path.join(settings.PROJECT_HOME, '../app/apps', app)
	if not os.path.isdir(app_dir):
		return ''

	items = ["<!-- start app medias for app %s -->" % app]
	views_dir = os.path.join(app_dir, 'static/js/view')
	if os.path.isdir(views_dir):
		pass

	dialogs_dir = os.path.join(app_dir, 'static/js/dialog')
	if os.path.isdir(dialogs_dir):
		for dialog_dir in os.listdir(dialogs_dir):
			#判断是否是合法的dialog目录
			dialog_js_path = os.path.join(dialogs_dir, dialog_dir, 'dialog.js')
			if not os.path.isfile(dialog_js_path):
				continue

			#读取dialog.js			
			src = open(dialog_js_path, 'rb')
			js_content = src.read()
			src.close()
			items.append("\t<!-- start %s/dialog.js -->" % dialog_dir)
			items.append('<script type="text/javascript">');
			items.append(js_content)
			items.append('</script>');
			items.append("\t<!-- finish %s/dialog.js -->" % dialog_dir)

			#读取dialog.html
			dialog_html_path = os.path.join(dialogs_dir, dialog_dir, 'dialog.html')
			src = open(dialog_html_path, 'rb')
			html_content = src.read()
			src.close()
			items.append("\t<!-- start %s/dialog.html -->" % dialog_dir)
			items.append(html_content)
			items.append("\t<!-- finish %s/dialog.html -->" % dialog_dir)

	if len(items) > 1:
		items.append("<!-- finish app medias for app %s -->" % app)
		return '\n'.join(items)
	else:
		return ''


def __read_file_conent(file_path):
	src = open(file_path, 'rb')
	content = src.read()
	src.close()

	return content.decode('utf-8')


@register.filter(name='load_wepage_components')
def load_wepage_components(app_components):
	app_components = json.loads(app_components)
	htmls = []
	jses = []
	csses = []
	designCsses = []
	htmls.append('<!-- start component templates -->\n<script id="componentTemplates" type="text/x-swig-tmpl">');
	jses.append('<!-- start component js codes -->');
	csses.append('<!-- start css -->\n<style type="text/css">');
	designCsses.append('<!-- start design css -->\n<style type="text/css">');

	components_dir = settings.WEPAGE_COMPONENTS_DIR
	for app_component in app_components:
		app_component_path = app_component.replace('.', '/')
		component_dir = os.path.join(components_dir, app_component_path)
		if not os.path.isdir(component_dir):
			print '[app] %s is not a valid app componet' % app_component

		for file_name in os.listdir(component_dir):
			if file_name.endswith('.js'):
				content = __read_file_conent(os.path.join(component_dir, file_name))
				jses.append(u"\t<!-- start %s/%s -->" % (app_component_path, file_name))
				jses.append(u'<script type="text/javascript">');
				jses.append(content)
				jses.append(u'</script>');
				jses.append(u"\t<!-- finish %s/%s -->" % (app_component_path, file_name))
			elif file_name.endswith('.html'):
				content = __read_file_conent(os.path.join(component_dir, file_name))
				htmls.append(content)
			elif file_name == 'style.css':
				content = __read_file_conent(os.path.join(component_dir, file_name))
				csses.append(u"/* from %s/%s */" % (app_component_path, file_name))
				csses.append(content)
			elif file_name == 'design.css':
				content = __read_file_conent(os.path.join(component_dir, file_name))
				designCsses.append(u"/* from %s/%s */" % (app_component_path, file_name))
				designCsses.append(content)
			else:
				print '[app] ignore %s' % file_name

	htmls.append('</script><!-- end component templates -->')
	jses.append('<!-- end component js codes -->')
	csses.append('</style><!-- end css -->')
	designCsses.append('</style><!-- end design css -->')

	content = u"%s\n%s\n%s\n%s\n" % (u'\n'.join(csses), u'\n'.join(designCsses), u'\n'.join(htmls), u'\n'.join(jses))
	return content.encode('utf-8')


@register.filter(name='load_wepage_property_fields')
def load_wepage_property_fields(args):
	field_templates_dir = settings.WEPAGE_PROPERTY_VIEW_FIELD_TEMPLATE_DIR
	field2template = {}
	jses = []
	for dir in os.listdir(field_templates_dir):
		field_name = dir;
		template_file = os.path.join(field_templates_dir, dir, 'template.html');
		css_file = os.path.join(field_templates_dir, dir, 'style.css');
		plugin_file = os.path.join(field_templates_dir, dir, 'plugin.js');
		
		if not os.path.exists(template_file):
			print '[WARN] field template %s is not exists!' % template_file
			continue

		template_content =  __read_file_conent(template_file)
		field2template[field_name] = template_content;

		if os.path.exists(plugin_file):
			js_content = __read_file_conent(plugin_file)
			jses.append('<!-- start ' + plugin_file + ' -->\n');
			jses.append(js_content);
			jses.append('<!-- finish ' + plugin_file + ' -->\n');

	buf = [];
	buf.append('<!-- start wepage property fields -->');
	buf.append('<script type="text/javascript">');
	buf.append('//property view field template');
	buf.append(u'W.__field2template = %s' % json.dumps(field2template));
	buf.append('</script>');

	buf.append('<script type="text/javascript" id="property-field-plugins">\n');
	buf.append(u'\n'.join(jses));
	buf.append('</script>');
	buf.append('<!-- finish wepage property fields -->');
	
	return u'\n'.join(buf).encode('utf-8');