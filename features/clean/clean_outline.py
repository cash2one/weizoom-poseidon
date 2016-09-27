# -*- coding: utf-8 -*-
import logging

from outline import models as outline_models
from account import models as account_models
from customer import models as customer_models
from application_audit import models as application_models

def clean():
	logging.info('clean database')
	outline_models.ProductModel.objects.all().delete()
	outline_models.Product.objects.all().delete()
	customer_models.CustomerMessage.objects.all().delete()
	customer_models.CustomerServerIps.objects.all().delete()
	application_models.ApplicationLog.objects.all().delete()
