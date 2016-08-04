# -*- coding: utf-8 -*-

from datetime import datetime

import mongoengine as models

class PageHtml(models.Document):
	related_page_id = models.StringField(default="", max_length=100) #termite page的id
	html = models.StringField() #html snippet

	meta = {
		'collection': 'page_html',
		'indexes': ['related_page_id']
	}