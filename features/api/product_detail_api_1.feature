# __author__ : "BenChi" 2016921

Feature: 提供商品详情的API
"""
	一、单规格商品
	二、多规格商品
	三、供货商对单规格商品修改（该场景应该在商品管理的feature场景中验证，无需在api中验证）
	四、供货商对多规格商品修改（该场景应该在商品管理的feature场景中验证，无需在api中验证）
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
					"image": "http://chaozhi.weizoom.comlove.png",
					"stocks": 100,
					"detail": "商品2描述信息"
				}
				"""
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000002",
					"name": "商品2",
					"promotion_title": "商品2促销",
					"weight": 1,
					"image": "http://chaozhi.weizoom.comlove.png",
					"detail": "商品1-1描述信息",
					"model": {
						"models":{
								"M": {
									"purchase_price": 301.00,
									"price": 301.00,
									"stocks": 101
								},
								"S": {
									"purchase_price": 300.00,
									"price": 300.00,
									"stocks": 101
								}
							}
						}
				}
				"""
	#自营平台从商品池上架商品
		Given zy1登录系统::weapp
		When zy1上架商品池商品"商品1-1"::weapp
		When zy1上架商品池商品"商品2"::weapp


	#开放平台中：创建使用账号 ，激活，审批 准许使用API接口
		Given manager登录开放平台系统
		When manager创建开放平台账号
		"""
			[{
			"account_name":"jd",
			"password":"123456",
			"account_main":"京东商城",
			"isopen":"是",
			"zy_account":"zy1"
			}]
		"""
		Given jd使用密码123456登录系统
		Then jd激活应用
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
		

Scenario:1 通过商品ID调用单规格商品API
	Then jd获取'000001'的商品详情
		"""
			{
				"name": "商品1-1",
				"price": 50.00,
				"weight": 1,
				"image": "http://chaozhi.weizoom.comlove.png",
				"stocks": 100,
				"detail": "商品1-1描述信息",
				"postage":[{
					"postage":10,
					"condition_money": "100"
				}]
			}
		"""

Scenario:2 通过商品ID调用多规格商品API
	Then jd获取'000002'的商品详情
		"""
			{
				"name": "商品2",
				"weight": 1,
				"image": "http://chaozhi.weizoom.comlove.png",
				"detail": "商品2描述信息",
				"model": {
						"models":{
								"M": {
									"price": 301.00,
									"stocks": 101
								},
								"S": {
									"price": 300.00,
									"stocks": 101
								}
							}
						},
				"postage":[{
					"postage":10,
					"condition_money": "100"
				}]
			}
		"""
Scenario:3 供货商修改单规格商品后，jd通过商品ID调用单规格商品API，获得修改后单规格商品详情
	#同步商品到自营平台（修改商品1中的价格，库存后进行同步）
		Given 给自营平台同步商品::weapp
			"""
			{
				"accounts":["zy1"],
				"supplier_name":"供货商1",
				"id": "000001",
				"name": "商品1-1",
				"promotion_title": "商品1-2促销",
				"purchase_price": 50.01,
				"price": 50.01,
				"weight": 1,
				"image": "love.png",
				"stocks": 101,
				"detail": "商品2描述信息"
			}
			"""

		Then jd获取'000001'的商品详情
			"""
				{
					"name": "商品1-1",
					"price": 50.01,
					"weight": 1,
					"image": "http://chaozhi.weizoom.comlove.png",
					"stocks": 101,
					"detail": "商品1-1描述信息",
					"postage":[{
						"postage":10,
						"condition_money": "100"
					}]
				}
			"""
Scenario:4 供货商修改多规格商品后，jd通过商品ID调用多规格商品API，获得修改后多规格商品详情
	#同步商品到自营平台（修改商品2中的价格，库存后进行同步）
		Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000002",
					"name": "商品2",
					"promotion_title": "商品2促销",
					"weight": 1,
					"image": "love.png",
					"detail": "商品1-1描述信息",
					"model": {
						"models":{
								"M": {
									"purchase_price": 302.00,
									"price": 302.00,
									"stocks": 102
								},
								"S": {
									"purchase_price": 300.00,
									"price": 300.00,
									"stocks": 102
								}
							}
						}
				}
				"""

	Then jd获取'000002'的商品详情
		"""
			{
				"name": "商品2",
				"weight": 1,
				"image": "http://chaozhi.weizoom.comlove.png",
				"detail": "商品2描述信息",
				"model": {
						"models":{
								"M": {
									"price": 302.00,
									"stocks": 102
								},
								"S": {
									"price": 300.00,
									"stocks": 102
								}
							}
						},
				"postage":[{
					"postage":10,
					"condition_money": "100"
				}]
			}
		"""