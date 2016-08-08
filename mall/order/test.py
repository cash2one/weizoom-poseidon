# -*- coding: utf-8 -*-
__author__ = 'justing'
# 

import sys
reload(sys)
sys.setdefaultencoding('utf-8')


import requests

headers = {'User-Agent': 'Mozilla/5print response.text.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36'}
params = {"access_token": "aaaaaaaa",'order_id':'20151217150256618','cur_page':1}
response = requests.get("http://127.0.0.1:8180/mall/order_list", params=params, headers=headers)
print response.text

params = {"access_token": "aaaaaaaa", 'order_id':'20160806111921285', 'express': 'ems', 'express_number':'888888888'}
response = requests.post("http://127.0.0.1:8180/mall/order_ship", data=params, headers=headers)

print 'express>>>',response.text
