# __author__ : "BenChi" 2016926

Feature: 提供商品库存的API
"""
	一、库存有限
	二、库存无限
	三、除下单外其它场景（取消订单，修改库存，退款完成）导致库存变化的场景，应该在具体的业务场景中验证，不在api场景中验证
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
		#同步商品到自营平台（库存有限）
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
					"detail": "商品2描述信息"
				}
				"""
		#同步商品到自营平台（库存无限）
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"id": "000002",
					"name": "商品2",
					"promotion_title": "商品1-2促销",
					"purchase_price": 50.00,
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stock_type": "无限",
					"detail": "商品2描述信息"
				}
				"""

	#开放平台中：创建使用账号 ，激活，审批 准许使用API接口
		Given manager登录开放平台系统
		When manager创建开放平台账号
		"""
			[{
			"acoount_name":"jd",
			"password":"123456",
			"account_main":"京东商城",
			"isopen":"是"
			}]
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
		Given manager登录开放平台系统
		When manager同意申请
			"""
				{
				"account_main":"京东商城"
				}
			"""
		
@chengdg
Scenario:1 通过商品ID调用单规格商品API
	Then jd获取'000001'的库存
		"""
			{
				"id": "000001",
				"stocks": 100
			}
		"""
	Then jd获取'000002'的库存
		"""
			{
				"id": "000002",
				"stock_type": "无限"
			}
		"""
Scenario:2 第三方平台产生订单后，库存有限的商品，库存扣减掉相应的购买量；库存无限的商品，库存类型不变，还是无限
	#第三方平台产生订单，自营平台生成对应的订单	
		Given 自营平台已获取jd订单
			"""
				{
					"order_no":"001",
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
		Then jd获取'000001'的库存
		"""
			{
				"id": "000001",
				"stocks": 99
			}
		"""
		Given 自营平台已获取jd订单
			"""
				{
					"order_no":"002",
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
							"name":"商品2",
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
		Then jd获取'000002'的库存
		"""
			{
				"id": "000002",
				"stock_type": "无限"
			}
		"""

