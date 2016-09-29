# __author__ : "BenChi" 2016926

Feature: 提供订单物流信息的API（单供货商）
"""
	
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
					"postage":10.0,
					"condition_money":100.0
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
					"weight": 1.0,
					"image": "http://chaozhi.weizoom.comlove.png",
					"stocks": 100,
					"detail": "商品1描述信息"
				}
				"""
	#自营平台从商品池上架商品
		Given zy1登录系统::weapp
		When zy1上架商品池商品"商品1-1"::weapp
		When zy1已添加支付方式::weapp
			"""
			[{
				"type": "微信支付",
				"is_active": "启用"
			}]
			"""					
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
		Then aini查看应用列表
			|application_name|    app_id    |   app_secret   |   status    |
			|    默认应用    |激活后自动生成| 激活后自动生成 |    未激活   |
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
		Then manager查看应用审核列表
			|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address  |status |   operation     |
			|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3 |http://192.168.0.130|待审核 |确认通过/驳回修改|
		When manager同意申请
			"""
				[{
				"account_main":"爱伲咖啡"
				}]
			"""
		Given aini使用密码123456登录系统
		Then aini查看应用列表
			|application_name|    app_id    |   app_secret   |   status    |
			|    默认应用    |    随机生成  |   随机生成     |    已启用   | 

		#aini获取acess_token
		When aini获取access_token
	#第三方平台产生订单，自营平台生成对应的订单
		Then aini获取'商品1-1'的商品详情
			"""
				{
					"name": "商品1-1",
					"price": 50.00,
					"weight": 1.0,
					"image": "http://chaozhi.weizoom.comlove.png",
					"stocks": 100,
					"detail": "商品1描述信息",
					"postage":[{
						"postage":10.0,
						"condition_money": 100.0
					}]
				}
			"""
		Given 自营平台'zy1'已获取aini订单
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
							"count":1,
							"single_save":0.00
						}],
						"postage": 10.0,
						"status":"待支付"
					}],
					"products_count":1,
					"total_price": 50.00,
					"postage": 10.0,
					"cash":50.00,
					"final_price": 60.00
				}
			"""
	#第三方平台中购买商品的用户，对订单进行完支付
		Given aini订单已支付
			"""
				{
					"order_no":"001",
					"methods_of_payment":"微信支付"
				}
			"""
Scenario:1 通过主订单ID提供订单详情API '已发货'，包括物流详细信息
	#Given 自营平台订单数据已同步到panda系统中
	Given zy1登录系统::weapp
	When zy1对订单进行发货::weapp
		"""
		{
			"order_no": "001-供货商1",
			"logistics": "申通快递",
			"number": "101002",
			"shipper": "pd|发货人备注信息"
		}
		"""

	When aini调用'订单详情'api
		"""
			{
				"order_no":"001"
			}
		"""
	Then aini获取'订单详情'api返回结果		
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
					"postage": 10.0,
					"status":"已发货"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.0,
				"cash":50.00,
				"final_price": 60.00,
				"logistics": "申通快递",
				"number": "101002",
				"shipper": "pd|发货人备注信息",
				"shipper_remark": "发货人备注信息"
			}
		"""
