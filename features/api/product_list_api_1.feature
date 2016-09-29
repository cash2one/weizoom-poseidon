# __author__ : "李娜" 2016921

Feature: 提供商品列表的API
"""
	一、通过列表页获取商品列表API
	二、每页最多存储两条商品列表信息
	三、（商品修改的验证应该在panda里进行验证，无需在开放平台再重复验证，先保留着，后续实现时讨论一下再删掉 by bc）
"""
Background:
	#重置weapp的bdd环境
		Given 重置'weapp'的bdd环境
		Given 设置zy1为自营平台账号::weapp
		Given zy1登录系统::weapp
	
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
					"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
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
					"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
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
					"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
					"stocks": 100,
					"detail": "商品3描述信息"
				}
				"""
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000004",
					"name": "商品2",
					"promotion_title": "商品2促销",
					"weight": 1,
					"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
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
		When zy1上架商品池商品"商品1-2"::weapp
		When zy1上架商品池商品"商品1-3"::weapp
		When zy1上架商品池商品"商品2"::weapp

	#开放平台中：创建使用账号 ，激活，审批 准许使用API接口
		Given manager登录开放平台系统
		When manager创建开放平台账号
		"""
			[{
			"account_name":"aini",
			"password":"123456",
			"account_main":"爱伲咖啡",
			"isopen":"是",
			"zy_account":"zy1"
			}]
		"""
		Given aini使用密码123456登录系统
		Then aini激活应用
			"""
				[{
				"dev_name":"爱伲咖啡",
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
				"account_main":"爱伲咖啡"
				}]
			"""
		

Scenario:1 通过列表页调用商品列表API
	When aini调用商品列表

	Then aini获取商品列表返回结果
		"""
			[{
				"name": "商品2",
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"model": {
						"models":{
								"M": {
									"price": 301.00,
									"sales": 0
								},
								"S": {
									"price": 300.00,
									"sales": 0
								}
							}
						}				
			},{
				"name": "商品1-3",
				"price": 50.00,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0				
			},{
				"name": "商品1-2",
				"price": 50.00,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0
			},{
				"name": "商品1-1",
				"price": 50.00,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0
			}]
		"""
Scenario:2 供货商修改单规格商品后，aini通过列表页调用单规格商品所在商品列表API，获得修改后单规格商品所在商品列表
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
					"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
					"stocks": 101,
					"detail": "商品2描述信息"
				}
				"""	
		When aini调用商品列表
		Then aini获取商品列表返回结果
		"""
			[{
				"name": "商品2",
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"model": {
						"models":{
								"M": {
									"price": 301.00,
									"sales": 0
								},
								"S": {
									"price": 300.00,
									"sales": 0
								}
							}
						}				
			},{
				"name": "商品1-3",
				"price": 50.00,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0				
			},{
				"name": "商品1-2",
				"price": 50.00,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0
			},{
				"name": "商品1-1",
				"price": 50.01,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0
			}]
		"""
Scenario:3 供货商修改多规格商品后，aini通过列表页调用多规格商品所在商品列表API，获得修改后多规格商品所在商品列表
	#同步商品到自营平台（修改商品2中的价格，库存后进行同步）
		Given 给自营平台同步商品::weapp
			"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000004",
					"name": "商品2",
					"promotion_title": "商品2促销",
					"weight": 1,
					"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
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
		When aini调用商品列表
		Then aini获取商品列表返回结果
		"""
			[{
				"name": "商品2",
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"model": {
						"models":{
								"M": {
									"price": 302.00,
									"sales": 0
								},
								"S": {
									"price": 300.00,
									"sales": 0
								}
							}
						}				
			},{
				"name": "商品1-3",
				"price": 50.00,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0				
			},{
				"name": "商品1-2",
				"price": 50.00,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0
			},{
				"name": "商品1-1",
				"price": 50.01,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"sales": 0
			}]
		"""
