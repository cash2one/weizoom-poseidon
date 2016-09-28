# __author__ : "李娜" 2016.09.22

Feature: 提供订单列表的API（存在两个单供货商订单、一个多供货商订单）
"""
	一、通过列表页获取订单列表API
	二、每页最多存储两条订单列表信息
"""
Background:
	#panda系统中：创建供货商、设置供货商运费、同步商品到自营平台
		#创建供货商
			Given 创建一个特殊的供货商，就是专门针对商品池供货商::weapp
				"""
				{
					"supplier_name":"供货商1"
				}
				"""
			Given 创建一个特殊的供货商，就是专门针对商品池供货商::weapp
				"""
				{
					"supplier_name":"供货商2"
				}
				"""
		#设置供货商运费
			#供货商1设置运费-满100包邮，否则收取运费10元
			When 给供货商添加运费配置::weapp
				"""
				{
					"supplier_name": "供货商1",
					"postage":10,
					"condition_money": "100"
				}
				"""
		#同步商品到自营平台
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000001",
					"name": "商品1",
					"promotion_title": "商品1促销",
					"purchase_price": 50.00,
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品1描述信息"
				}
				"""
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商2",
					"id": "000002",
					"name": "商品2",
					"promotion_title": "商品2促销",
					"purchase_price": 50.00,
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品2描述信息"
				}
				"""			
	#开放平台中：创建使用账号 ，激活，审批 准许使用API接口
		Given manager登录开放平台系统
		When manager创建开放平台账号
			"""
				[{
				"account_name":"jd",
				"password":"123456",
				"account_main":"京东商城",
				"isopen":"是"
				}]
			"""
		Given jd使用密码123456登录系统
		When jd激活应用
			"""
				[{
				"dev_name":"京东商城",
				"mobile_num":"13813984405",
				"e_mail":"ainicoffee@qq.com",
				"ip_address":"192.168.1.3",
				"interface_address":"http://192.168.0.130"
				}]
			"""
		Given manager登录开放平台系统
		When manager同意申请
			"""
				[{
				"account_main":"京东商城"
				}]
			"""
		Then jd获取'000001'的商品详情
			"""
				{
					"id": "000001",
					"name": "商品1",
					"promotion_title": "商品1-2促销",
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品1-1描述信息",
					"postage":[{
						"postage":10,
						"condition_money": "100"
					}]
				}
			"""
		Then jd获取'000002'的商品详情
			"""
				{
					"id": "000002",
					"name": "商品2",
					"promotion_title": "商品1-2促销",
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品1-1描述信息",
					
				}
			"""
		Given 自营平台已获取jd订单
			"""
				{
					"order_no":"001",
					"deal_id":"01",
					"status":"待支付",
					"ship_name":"bill",
					"ship_tel":"13811223344",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦",
					"invoice":"",
					"business_message":"",
					"methods_of_payment":"",
					"group":[{
						"order_no":"001-供货商1",
						"products":[{
							"name":"商品1",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.00,
						"status":"待支付"
					},{
						"order_no":"001-供货商2",
						"products":[{
							"name":"商品2",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 0.00,
						"status":"待支付"
					}],
					"products_count":2,
					"total_price": 100.00,
					"postage": 10.00,
					"cash":100.00,
					"final_price": 110.00
				}
			"""
		Given 自营平台已获取jd订单
			"""
				{
					"order_no":"002",
					"deal_id":"02",
					"status":"待支付",
					"ship_name":"bill",
					"ship_tel":"13811223344",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦",
					"invoice":"",
					"business_message":"",
					"methods_of_payment":"",
					"group":[{
						"order_no":"002-供货商1",
						"products":[{
							"name":"商品1-1",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.00,
						"status":"待支付"
					}],
					"products_count":1,
					"total_price": 50.00,
					"postage": 10.00,
					"cash":50.00,
					"final_price": 60.00
				}
			"""
		Given 自营平台已获取jd订单
			"""
				{
					"order_no":"003",
					"deal_id":"03",
					"status":"待支付",
					"ship_name":"bill",
					"ship_tel":"13811223344",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦",
					"invoice":"",
					"business_message":"",
					"methods_of_payment":"",
					"group":[{
						"order_no":"003-供货商1",
						"products":[{
							"name":"商品1-1",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.00,
						"status":"待支付"
					}],
					"products_count":1,
					"total_price": 50.00,
					"postage": 10.00,
					"cash":50.00,
					"final_price": 60.00
				}
			"""
Scenario:1 通过列表页调用订单列表API
	When jd调用'订单列表'api
		"""
			{
				"cur_page":1,
				"count_per_page":2
			}
		"""			
	Then jd获取'订单列表'api返回结果
		"""
			[{
				"order_no":"001",
				"deal_id":"01",
				"status":"待支付",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_area": "北京市 北京市 海淀区",
				"ship_address": "泰兴大厦",
				"invoice":"",
				"business_message":"",
				"methods_of_payment":"",
				"group":[{
					"order_no":"001-供货商1",
					"products":[{
						"name":"商品1",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
					"postage": 10.00,
					"status":"待支付"
				},{
					"order_no":"001-供货商2",
					"products":[{
						"name":"商品2",
						"price":50.00,
						"count":1
						"single_save":0.00
					}],
					"postage": 0.00,
					"status":"待支付"
				}],
				"products_count":2,
				"total_price": 100.00,
				"postage": 10.00,
				"cash":100.00,
				"final_price": 110.00
			},{
				"order_no":"002",
				"deal_id":"02",
				"status":"待支付",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_area": "北京市 北京市 海淀区",
				"ship_address": "泰兴大厦",
				"invoice":"",
				"business_message":"",
				"methods_of_payment":"",
				"group":[{
					"order_no":"002-供货商1",
					"products":[{
						"name":"商品1-1",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
					"postage": 10.00,
					"status":"待支付"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"cash":50.00,
				"final_price": 60.00
			}]
		"""	
	When jd调用'订单列表'api
		"""
			{
				"cur_page":2,
				"count_per_page":2
			}
		"""
	Then jd获取'订单列表'api返回结果
		"""
			[{
				"order_no":"003",
				"deal_id":"03",
				"status":"待支付",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_area": "北京市 北京市 海淀区",
				"ship_address": "泰兴大厦",
				"invoice":"",
				"business_message":"",
				"methods_of_payment":"",
				"group":[{
					"order_no":"003-供货商1",
					"products":[{
						"name":"商品1-1",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
					"postage": 10.00,
					"status":"待支付"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"cash":50.00,
				"final_price": 60.00
			}]
		"""	
