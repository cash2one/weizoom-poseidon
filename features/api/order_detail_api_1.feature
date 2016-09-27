# __author__ : "BenChi" 2016921

Feature: 提供订单详情的API（单供货商）
"""
	待支付，待发货，已发货，已完成
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
					"name": "商品1-1",
					"promotion_title": "商品1-2促销",
					"purchase_price": 50.00,
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品1描述信息"
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
	#第三方平台产生订单，自营平台生成对应的订单	
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
							"name":"商品1-1",
							"price":50.00,
							"count":1
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
Scenario:1 通过主订单ID提供订单详情API '待支付'
	
	When jd调用'订单详情'api
		"""
			{
				"order_no":"001"
			}
		"""
	Then jd获取'订单详情'api返回结果		
		"""
			{
				"order_no":"001",
				"deal_id":"01",
				"status":"待支付",
				"_nshipame":"bill",
				"ship_tel":"13811223344",
				"ship_area": "北京市 北京市 海淀区",
				"ship_address": "泰兴大厦",
				"invoice":"",
				"business_message":"",
				"methods_of_payment":"",
				"group":[{
					"order_no":"001-供货商1",
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
Scenario:2 通过主订单ID提供订单详情API '待发货'
	Given jd订单已支付
		"""
			{
				"order_no":"001",
				"methods_of_payment":"微信支付"
			}
		"""
	When jd调用'订单详情'api
		"""
			{
				"order_no":"001"
			}
		"""
	Then jd获取'订单详情'api返回结果		
		"""
			{
				"order_no":"001",
				"deal_id":"01",
				"status":"待发货",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_area": "北京市 北京市 海淀区",
				"ship_address": "泰兴大厦",
				"invoice":"",
				"business_message":"",
				"methods_of_payment":"微信支付",
				"group":[{
					"order_no":"001-供货商1",
					"products":[{
						"name":"商品1-1",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
					"postage": 10.00,
					"status":"待发货"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"cash":50.00,
				"final_price": 60.00
			}
		"""
Scenario:3 通过主订单ID提供订单详情API '已发货'
	Given jd订单已支付
		"""
			{
				"order_no":"001",
				"methods_of_payment":"微信支付"
			}
		"""
	#Given 自营平台订单数据已同步到panda系统中
	Given pd登录panda系统
	When pd对订单进行发货::weapp
		"""
			{
			"order_no": "001-供货商1",
			"logistics": "申通快递",
			"number": "101002",
			"shipper": "pd"
			}
		"""
	When jd调用'订单详情'api
		"""
			{
				"order_no":"001"
			}
		"""
	Then jd获取'订单详情'api返回结果		
		"""
			{
				"order_no":"001",
				"deal_id":"01",
				"status":"已发货",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_area": "北京市 北京市 海淀区",
				"ship_address": "泰兴大厦",
				"invoice":"",
				"business_message":"",
				"methods_of_payment":"微信支付",
				"group":[{
					"order_no":"001-供货商1",
					"products":[{
						"name":"商品1-1",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
					"postage": 10.00,
					"status":"已发货"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"cash":50.00,
				"final_price": 60.00
			}
		"""
Scenario:4 通过主订单ID提供订单详情API '已完成'
	Given jd订单已支付
		"""
			{
				"order_no":"001",
				"methods_of_payment":"微信支付"
			}
		"""
	#Given 自营平台订单数据已同步到panda系统中
	Given pd登录panda系统
	When pd完成订单'001-供货商1'::weapp
	When jd调用'订单详情'api
		"""
			{
				"order_no":"001"
			}
		"""
	Then jd获取'订单详情'api返回结果		
		"""
			{
				"order_no":"001",
				"deal_id":"01",
				"status":"已完成",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_area": "北京市 北京市 海淀区",
				"ship_address": "泰兴大厦",
				"invoice":"",
				"business_message":"",
				"methods_of_payment":"微信支付",
				"group":[{
					"order_no":"001-供货商1",
					"products":[{
						"name":"商品1-1",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
					"postage": 10.00,
					"status":"已完成"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"cash":50.00,
				"final_price": 60.00
			}
		"""