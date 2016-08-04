# -*- coding: utf-8 -*-

import json

class FrontEndData(object):
	def __init__(self):
		self.jsons = {'items':[]}

	def add(self, name, value):
		self.jsons['items'].append((name, json.dumps(value)))

	def add_user_permissions(self, user):
		data = []
		for permission in user.user_permissions.all():
			data.append('permission.%s' % permission.codename)
		self.add('__userPermissions', data)

	def get(self, name):
		for item in self.jsons['items']:
			if item[0] == name:
				return json.loads(item[1])