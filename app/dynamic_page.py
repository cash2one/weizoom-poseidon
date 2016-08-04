# -*- coding: utf-8 -*-

import json
from datetime import datetime
import time

from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.db.models import F
from django.contrib.auth.decorators import login_required

from core import resource
from core import paginator
from core.jsonresponse import create_response

import pagestore as pagestore_manager
import models

class Page(resource.Resource):
	app = 'app.dynamic_page'
	resource = 'page'
	
	@login_required
	def api_get(request):		
		pagestore = pagestore_manager.get_pagestore('mongo')

		project_id = request.GET['project_id']
		_, app_name, real_project_id = project_id.split(':')
		if real_project_id == '0':
			#新建app的project
			app_settings_module_path = 'app.apps.%s.settings' % app_name
			app_settings_module = __import__(app_settings_module_path, {}, {}, ['*',])
			page = json.loads(app_settings_module.NEW_PAGE_JSON)
			page['component']['page_id'] = page['page_id']
			page = page['component']
		else:
			page = pagestore.get_page_components(real_project_id)[0]
				
		response = create_response(200)
		response.data = page
		return response.get_response()


	@staticmethod
	def create_empty_app_page(request):
		"""
		创建新的
		"""
		project_id = request.POST['id']
		_, app_name, _ = project_id.split(':')
		page_component = json.loads(request.POST['page_json'])
		page_component['is_new_created'] = True
		page_id = 1
		project_id = 'app:%s:%s:%s' % (app_name, request.manager.id, time.time())
		pagestore = pagestore_manager.get_pagestore_by_type('mongo')
		pagestore.save_page(project_id, page_id, page_component)

		page = pagestore.get_page(project_id, page_id)
		new_project_id = str(page['_id'])
		pagestore.update_page_project_id(project_id, page_id, new_project_id)

		#save page html
		html = request.POST.get('page_html', '')
		pageHtml = models.PageHtml(
			related_page_id = new_project_id,
			html = html.encode('utf-8')
		)
		pageHtml.save()

		return new_project_id

	@staticmethod
	def update_app_page_content(request):
		"""
		更新app page内容
		"""
		project_id = request.POST['id']
		_, app_name, project_id = project_id.split(':')
		pagestore = pagestore_manager.get_pagestore('mongo')
		page_id = 1
		page = json.loads(request.POST['page_json'])
		pagestore.save_page(project_id, page_id, page)

		# update page html
		page_id = project_id
		html = request.POST.get('page_html', None)
		if html:
			models.PageHtml.objects(related_page_id=page_id).update(set__html=request.POST['page_html'])
	
	@login_required
	def api_post(request):
		"""
		保存(更新)page
		"""
		project_id = request.POST['id']
		if project_id.startswith('new_app:'):
			if project_id.endswith(':0'):
				project_id = Page.create_empty_app_page(request)
				response = create_response(200)
				response.data = {
					'project_id': project_id
				}
				return response.get_response()
			else:
				Page.update_app_page_content(request)
		else:
			pass
			#清除webapp page cache
			#Page.delete_webapp_page_cache(request.manager.id, project_id)

		response = create_response(200)
		return response.get_response()
