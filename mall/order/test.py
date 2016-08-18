# -*- coding: utf-8 -*-
__author__ = 'justing'
# 

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import json


import requests
domain = 'http://127.0.0.1:8280/'
headers = {'User-Agent': 'Mozilla/5print response.text.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36'}
params = {"access_token": "aaaaaaaa",'order_id':'20151217150256618','cur_page':1}

#zeus order_id暂不支持
# params = {"access_token": "aaaaaaaa",'order_id':'20151217150256618','cur_page':1, 'order_status':4}
# params = {"access_token": "aaaaaaaa",'order_id':'20151217150256618','cur_page':1, 'order_id':'20160818121223340'}

# response = requests.get("{}{}".format(domain, "mall/order_list"), params=params, headers=headers)
# # print response.text

# print json.loads(response.text)
# print json.loads(response.text)['data']['orders'][0]['products']

params = {"access_token": "aaaaaaaa", 'order_id':'20160818120117692', 'express': 'shentong', 'express_number':'333333333333'}
response = requests.post("{}{}".format(domain, "mall/order_ship"), data=params, headers=headers)

print 'express>>>',response.text
