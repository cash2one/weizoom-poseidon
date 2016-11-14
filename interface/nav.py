# -*- coding: utf-8 -*-
__author__ = 'hj'

SECOND_NAVS = [{
	'name': 'interface-token',
	'displayName': '获取Token',
	'href': '/static/wiki/get_token.html'
},{
	'name': 'interface-product',
	'displayName': '商品API',
	'href': '/interface/product_api/'
},
{
	'name': 'interface-order',
	'displayName': '订单API',
	'href': '/interface/order_api/'
},
{
	'name': 'interface-area',
	'displayName': '地址区域',
	'href': '/static/wiki/area.html'
},
{
	'name': 'interface-notify',
	'displayName': '通知',
	'href': '/static/wiki/notify.html'
},
{
	'name': 'interface-supplier',
	'displayName': '供货商API',
	'href': '/interface/supplier_api/'
}
]

def get_second_navs():
	return SECOND_NAVS