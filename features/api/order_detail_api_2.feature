# __author__ : "李娜" 2016.09.21

Feature: 提供订单详情的API（多供货商）
"""
	待支付，待发货，已发货，已完成
"""
Background:
	#重置weapp的bdd环境
		Given 重置'weapp'的bdd环境
		Given 设置zy1为自营平台账号::weapp
		Given zy1登录系统::weapp
	#panda系统中：创建供货商、设置供货商运费、同步商品到自营平台
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
		Then jd查看应用列表
		|application_name|    app_id    |   app_secret   |   status    |
		|    默认应用    |激活后自动生成| 激活后自动生成 |    未激活   |
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
		
		Then manager查看应用审核列表
			|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
			|  京东商城  |  默认应用      |审核后自动生成|审核后自动生成|京东商城|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改|

		When manager同意申请
			"""
				[{
				"account_main":"京东商城"
				}]
			"""
		Given jd使用密码123456登录系统
		Then jd查看应用列表
			|application_name|    app_id    |   app_secret   |   status    |
			|    默认应用    |    随机生成  |   随机生成     |    已启用   | 

		When jd获取access_token

	
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
			When 给供货商'供货商1'添加运费配置::weapp
				"""
				[{
					"name":"圆通",
					"first_weight": 0,
					"first_weight_price": 10.00,
					"added_weight": 0,
					"added_weight_price": 0.00,
					"free_postages": [{
						"to_the":"北京市",
						"condition": "count",
						"value": 2
					}, {
						"to_the":"北京市",
						"condition": "money",
						"value": 100.00
					}]
				}]
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
					"image": "http://chaozhi.weizoom.comlove.png",
					"postage": "系统",
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
					"image": "http://chaozhi.weizoom.comlove.png",
					"postage": "0.0",
					"stocks": 100,
					"detail": "商品2描述信息"
				}
				"""
	#自营平台从商品池上架商品
		Given zy1登录系统::weapp
		When zy1上架商品池商品"商品1"::weapp
		When zy1上架商品池商品"商品2"::weapp
		When zy1已添加支付方式::weapp
			"""
			[{
				"type": "微信支付",
				"is_active": "启用"
			}]
			"""

		When 给供货商选择运费配置::weapp
		"""
		{
			"supplier_name": "供货商1",
			"postage_name": "圆通"
		}
		"""

		Then jd获取'商品1'的商品详情
			"""
				{
					"name": "商品1",
					"price": 50.00,
					"weight": 1,
					"image": "http://chaozhi.weizoom.comlove.png",
					"stocks": 100,
					"detail": "商品1描述信息",
					"unified_postage_money": 0.0,
					"postage_type": "custom_postage_type",
					"supplier_postage_config": {
				        "isEnableAddedWeight": true,
				        "addedWeight": 0.0,
				        "firstWeight": 0.0,
				        "addedWeightPrice": 0.0,
				        "firstWeightPrice": 10.0,
				        "free_factor": {
				            "province_1": [
				                {
				                    "condition_value": 2,
				                    "condition": "count"
				                },
				                {
				                    "condition_value": 100.0,
				                    "condition": "money"
				                }
				            ]
				        }
				    }
				}
			"""
		Then jd获取'商品2'的商品详情
			"""
				{
					"name": "商品2",
					"price": 50.00,
					"weight": 1,
					"image": "http://chaozhi.weizoom.comlove.png",
					"stocks": 100,
					"detail": "商品2描述信息",
					"unified_postage_money": 0.0,
					"postage_type": "unified_postage_type",
					"supplier_postage_config": {}
				}
			"""
		Given 自营平台'zy1'已获取jd订单
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
		When zy1修改订单编号"001"::weapp

@openapi @order @houtf
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
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_area": "北京市 北京市 海淀区",
				"ship_address": "泰兴大厦",
				"invoice":"",
				"business_message":"",
				"methods_of_payment":"",
				"products":[{
						"name":"商品1",
						"price":50.00,
						"count":1,
						"single_save":0.00
					},{
						"name":"商品2",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
				"products_count":2,
				"total_price": 100.00,
				"postage": 10.00,
				"cash":100.00,
				"final_price": 110.00
			}
		"""
@openapi @order @houtf
Scenario:2 通过主订单ID提供订单详情API '待发货'
	Given jd订单已支付
		"""
			{
				"order_no":"001",
				"methods_of_payment":"微信支付"
			}
		"""
	#商品1-1待发货，商品2-1待发货	
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
							"name":"商品1",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.00,
						"status":"待发货"
					},{
						"order_no":"001-供货商2",
						"products":[{
							"name":"商品2",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 0.00,
						"status":"待发货"
					}],
					"products_count":2,
					"total_price": 100.00,
					"postage": 10.00,
					"cash":100.00,
					"final_price": 110.00
				}
			"""
	#商品1-1已发货，商品2-1待发货
		#Given 自营平台订单数据已同步到panda系统中
		#Given pd登录panda系统
		Given zy1登录系统::weapp
		When zy1对订单进行发货::weapp
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
							"name":"商品1",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.00,
						"status":"已发货"
					},{
						"order_no":"001-供货商2",
						"products":[{
							"name":"商品2",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 0.00,
						"status":"待发货"
					}],
					"products_count":2,
					"total_price": 100.00,
					"postage": 10.00,
					"cash":100.00,
					"final_price": 110.00
				}
			"""
	#商品1-1已完成，商品2-1待发货	
		#Given 自营平台订单数据已同步到panda系统中
		#Given pd登录panda系统
		Given zy1登录系统::weapp
		When zy1完成订单'001-供货商1'::weapp
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
							"name":"商品1",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.00,
						"status":"已完成"
					},{
						"order_no":"001-供货商2",
						"products":[{
							"name":"商品2",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 0.00,
						"status":"待发货"
					}],
					"products_count":2,
					"total_price": 100.00,
					"postage": 10.00,
					"cash":100.00,
					"final_price": 110.00
				}
			"""
@openapi @order @houtf
Scenario:3 通过主订单ID提供订单详情API '已发货'
	Given jd订单已支付
		"""
			{
				"order_no":"001",
				"methods_of_payment":"微信支付"
			}
		"""
	#商品1-1已发货，商品2-1已发货
		#Given 自营平台订单数据已同步到panda系统中
		Given zy1登录系统::weapp
		When zy1对订单进行发货::weapp
	        """
	        {
	          "order_no": "001-供货商1",
	          "logistics": "申通快递",
	          "number": "101001",
	          "shipper": "pd"
	        }
	        """
	    When zy1对订单进行发货::weapp
	    	"""
	        {
	          "order_no": "001-供货商2",
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
							"name":"商品1",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.00,
						"status":"已发货"
					},{
						"order_no":"001-供货商2",
						"products":[{
							"name":"商品2",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 0.00,
						"status":"已发货"
					}],
					"products_count":2,
					"total_price": 100.00,
					"postage": 10.00,
					"cash":100.00,
					"final_price": 110.00
				}
			"""
	#商品1-1已完成，商品2-1已发货
		#Given 自营平台订单数据已同步到panda系统中
		Given zy1登录系统::weapp
		When zy1完成订单'001-供货商1'::weapp
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
							"name":"商品1",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.00,
						"status":"已完成"
					},{
						"order_no":"001-供货商2",
						"products":[{
							"name":"商品2",
							"price":50.00,
							"count":1,
							"single_save":0.00
						}],
						"postage": 0.00,
						"status":"已发货"
					}],
					"products_count":2,
					"total_price": 100.00,
					"postage": 10.00,
					"cash":100.00,
					"final_price": 110.00
				}
			"""
@openapi @order @houtf
Scenario:4 通过主订单ID提供订单详情API '已完成'
	Given jd订单已支付
		"""
			{
				"order_no":"001",
				"methods_of_payment":"微信支付"
			}
		"""
	#Given 自营平台订单数据已同步到panda系统中
	#Given pd登录panda系统
	Given zy1登录系统::weapp
	When zy1完成订单'001-供货商1'::weapp
	When zy1完成订单'001-供货商2'::weapp

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
						"name":"商品1",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
					"postage": 10.00,
					"status":"已完成"
				},{
					"order_no":"001-供货商2",
					"products":[{
						"name":"商品2",
						"price":50.00,
						"count":1,
						"single_save":0.00
					}],
					"postage": 0.00,
					"status":"已完成"
				}],
				"products_count":2,
				"total_price": 100.00,
				"postage": 10.00,
				"cash":100.00,
				"final_price": 110.00
			}
		"""