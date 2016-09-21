# __author__ : "BenChi"

Feature: 提供商品详情的API
"""
	一、单规格商品
	二、多规格商品
	三、供货商对单规格商品修改
	四、供货商对多规格商品修改
"""
Background:
	#panda系统中：创建供货商、设置供货商运费、同步商品到自营平台
		#创建供货商
			Given 创建一个特殊的供货商，就是专门针对商品池供货商
				"""
				{
					"supplier_name":"供货商1"
				}
				"""
		#设置供货商运费
			#供货商1设置运费-满100包邮，否则收取运费10元
			When 给供货商添加运费配置
				"""
				{
					"supplier_name": "供货商1",
					"postage":10,
					"condition_money": "100"
				}
				"""
		#同步商品到自营平台
			Given 给自营平台同步商品
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000001",
					"name": "商品1-1",
					"promotion_title": "商品1-2促销",
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品2描述信息"
				}
				"""
			Given 给自营平台同步商品
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
									"price": 301.00,
									"stock_type": "无限"
								},
								"S": {
									"price": 300.00,
									"stock_type": "无限"
								}
							}
						}
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
		

Scenario:1 通过商品ID调用单规格商品API
	When jd调用'商品详情'api
		"""
			{
				"productId":"000001"
			}
		"""
	Then jd获取'商品详情'api返回结果
		"""
			{
				"id": "000001",
				"name": "商品1-1",
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
Scenario:2 通过商品ID调用多规格商品API
	When jd调用'商品详情'api
		"""
			{
				"productId":"000002"
			}
		"""
	Then jd获取'商品详情'api返回结果
		"""
			{
				"id": "000002",
				"name": "商品2",
				"promotion_title": "商品2促销",
				"weight": 1,
				"image": "love.png",
				"detail": "商品2描述信息",
				"model": {
						"models":{
								"M": {
									"price": 301.00,
									"stock_type": "无限"
								},
								"S": {
									"price": 300.00,
									"stock_type": "无限"
								}
							}
						},
				"postage":[{
					"postage":10,
					"condition_money": "100"
				}]
			}
		"""