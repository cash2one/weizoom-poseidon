# -*- coding: utf-8 -*-

from django.db.models import F
from django.db import IntegrityError, transaction

#from mall.promotion.models import CouponRule
#from mall.promotion import models as promotion_models
#from market_tools.tools.coupon.util import consume_coupon

__author__ = 'robert'

from datetime import datetime
import json

from django.db.models import Q
from django.http import HttpResponseRedirect, HttpResponse, HttpRequest, Http404
from django.template import Context, RequestContext
from django.contrib.auth.decorators import login_required
from django.conf import settings
from django.shortcuts import render_to_response, render
from django.contrib.auth.models import User
from django.contrib import auth


#===============================================================================
# __get_fields_to_be_save : 获得待存储的数据
#===============================================================================
def get_fields_to_be_save(request):
	fields = request.POST.dict()
	fields['created_at'] = datetime.today()

	webapp_user = getattr(request, 'webapp_user', None)
	if webapp_user:
		fields['webapp_user_id'] = request.webapp_user.id

	member = getattr(request, 'member', None)
	if member:
		fields['member_id'] = request.member.id
		fields['owner_id'] = request.user.id
	else:
		fields['owner_id'] = request.manager.id

	if 'prize' in request.POST:
		fields['prize'] = json.loads(fields['prize'])

	if 'termite_data' in fields:
		fields['termite_data'] = json.loads(fields['termite_data'])
		for item in fields['termite_data']:
			att_url = []
			if fields['termite_data'][item]['type']=='appkit.uploadimg':
				fields['uploadImg'] = json.loads(fields['termite_data'][item]['value'])
				for picture in fields['uploadImg']:
					att_url.append(picture)
				fields['termite_data'][item]['value'] = att_url
	return fields

