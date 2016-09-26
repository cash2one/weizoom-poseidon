# __author__ : "李娜" 2016923

Feature: 提供商品列表的API
"""
	一、通过列表页获取商品列表API
	二、每页最多存储两条商品列表信息
	三、（商品修改的验证应该在panda里进行验证，无需在开放平台再重复验证，先保留着，后续实现时讨论一下再删掉 by bc）
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
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000002",
					"name": "商品1-2",
					"promotion_title": "商品1-2促销",
					"purchase_price": 50.00,
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品2描述信息"
				}
				"""
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000003",
					"name": "商品1-3",
					"promotion_title": "商品1-2促销",
					"purchase_price": 50.00,
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品3描述信息"
				}
				"""

	#开放平台中：创建使用账号 ，激活，审批 准许使用API接口
		Given manager登录系统:开放平台
		When manager创建账号
		"""
			{
			"acoount_name":"jd",
			"password":"123456",
			"account_main":"京东商城",
			"isopen":"是"
			}
		"""
		Given jd使用密码123456登录系统
		When jd激活应用
			"""
				{
				"dev_name":"京东商城",
				"mobile_num":"13813984405",
				"e_mail":"ainicoffee@qq.com",
				"ip_address":"192.168.1.3",
				"interface_address":"http://192.168.0.130"
				}
			"""
		Given manager登录系统:开放平台
		When manager同意申请
			"""
				{
				"account_main":"京东商城"
				}
			"""
		

Scenario:1 通过列表页调用商品列表API
	When jd调用'商品列表'api
		"""
			{
				"cur_page":1,
				"count_per_page":2
			}
		"""
	Then jd获取'商品列表'api返回结果
		"""
			[{
				"id": "000001",
				"name": "商品1-1",
				"promotion_title": "商品1-2促销",
				"price": 50.00,
				"weight": 1,
				"image": "love.png",
				"stocks": 100,
				"detail": "商品1描述信息",
				"postage":[{
					"postage":10,
					"condition_money": "100"
				}]
			},{
				"id": "000002",
				"name": "商品1-2",
				"promotion_title": "商品1-2促销",
				"price": 50.00,
				"weight": 1,
				"image": "love.png",
				"stocks": 100,
				"detail": "商品2描述信息",
				"postage":[{
					"postage":10,
					"condition_money": "100"
				}]
			}]
		"""
	When jd调用'商品列表'api
		"""
			{
				"cur_page":2,
				"count_per_page":2
			}
		"""
	Then jd获取'商品列表'api返回结果
		"""
			[{
				"id": "000003",
				"name": "商品1-3",
				"promotion_title": "商品1-2促销",
				"price": 50.00,
				"weight": 1,
				"image": "love.png",
				"stocks": 100,
				"detail": "商品3描述信息",
				"postage":[{
					"postage":10,
					"condition_money": "100"
				}]
			}]
		"""
Scenario:2 供货商修改单规格商品后，jd通过列表页调用单规格商品所在商品列表API，获得修改后单规格商品所在商品列表
	#同步商品到自营平台（修改商品1中的价格，库存后进行同步）
		Given 给自营平台同步商品
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
		When jd调用'商品列表'api
			"""
				{
					"cur_page":1,
					"count_per_page":2
				}
			"""
		Then jd获取'商品列表'api返回结果
			"""
				[{
					"id": "000001",
					"name": "商品1-1",
					"promotion_title": "商品1-2促销",
					"price": 50.01,
					"weight": 1,
					"image": "love.png",
					"stocks": 101,
					"detail": "商品2描述信息",
					"postage":[{
						"postage":10,
						"condition_money": "100"
					}]
				},{
					"id": "000002",
					"name": "商品1-2",
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
				}]
			"""
