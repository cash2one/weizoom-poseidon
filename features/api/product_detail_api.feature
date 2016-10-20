# __author__ : "BenChi" 2016923

Feature: 提供商品详情的API
"""
	一、单规格商品
	二、供货商对单规格商品修改（该场景应该在商品管理的feature场景中验证，无需在api中验证）

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
		##给供货商1配置两个运费模板-顺丰-只有首重，中通-包含续重，特殊地区包邮条件
			When 给供货商'供货商1'添加运费配置::weapp
			"""
			[{
				"name": "顺丰",
				"first_weight": 0.1,
				"first_weight_price": 10.00
			},{
				"name":"中通",
				"first_weight": 1,
				"first_weight_price": 13.00,
				"added_weight": 1,
				"added_weight_price": 5.00,
				"special_area": [{
					"to_the":"北京市,江苏省",
					"first_weight": 1,
					"first_weight_price": 20.00,
					"added_weight": 1,
					"added_weight_price": 10.00
				}],
				"free_postages": [{
					"to_the":"北京市",
					"condition": "count",
					"value": 3
				}, {
					"to_the":"北京市",
					"condition": "money",
					"value": 100.00
				}]
			},{
				"name":"申通",
				"first_weight": 1,
				"first_weight_price": 13.00,
				"added_weight": 1,
				"added_weight_price": 5.00,
				"special_area": [{
					"to_the":"北京市,江苏省",
					"first_weight": 1,
					"first_weight_price": 20.00,
					"added_weight": 1,
					"added_weight_price": 10.00
				}]
			},{
				"name":"圆通",
				"first_weight": 1,
				"first_weight_price": 13.00,
				"added_weight": 1,
				"added_weight_price": 5.00,
				"free_postages": [{
					"to_the":"北京市",
					"condition": "count",
					"value": 3
				}, {
					"to_the":"北京市",
					"condition": "money",
					"value": 100.00
				}]
			}]
			"""

		#商品1和商品2选系统运费，商品3统一运费
		#同步商品到自营平台
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"name": "商品1-1",
					"promotion_title": "商品1-2促销",
					"purchase_price": 40.00,
					"price": 50.00,
					"weight": 1,
					"postage": "系统",
					"image": "love.png",
					"stocks": 100,
					"detail": "商品1-1描述信息"
				}
				"""
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"name": "商品2-1",
					"promotion_title": "商品1-2促销",
					"purchase_price": 9.00,
					"price": 10.00,
					"weight": 1,
					"postage": "10.0",
					"image": "love.png",
					"stocks": 100,
					"detail": "商品1-2描述信息"
				}
				"""
			Given 给自营平台同步商品::weapp
				"""
				{
					"accounts":["zy1"],
					"supplier_name":"供货商1",
					"name": "商品3-1",
					"promotion_title": "商品1-2促销",
					"purchase_price": 9.00,
					"price": 10.00,
					"weight": 1,
					"postage": 0.00,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品1-2描述信息"
				}
				"""

		#自营平台从商品池上架商品
			Given zy1登录系统::weapp
			When zy1上架商品池商品"商品1-1"::weapp
			When zy1上架商品池商品"商品2-1"::weapp
			When zy1上架商品池商品"商品3-1"::weapp
			
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
			|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
			|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改|
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

@openapi @chengdg
Scenario:1 通过商品ID调用单规格商品API,模板运费：首重+特殊地区+包邮
	When 给供货商选择运费配置::weapp
		"""
		{
			"supplier_name": "供货商1",
			"postage_name": "中通"
		}
		"""
	Then aini获取'商品1-1'的商品详情
		"""
			{
				"name": "商品1-1",
				"price": 50.00,
				"weight": 1.0,
				"image": "http://chaozhi.weizoom.comlove.png",
				"stocks": 100,
				"detail": "商品1-1描述信息",
				"unified_postage_money": 0.0,
				"postage_type": "custom_postage_type",
				"supplier_postage_config": {
			        "special_factor": {
			            "province_1": {
			                "firstWeight": 1.0,
			                "firstWeightPrice": 20.0,
			                "addedWeight": 1.0,
			                "addedWeightPrice": 10.0
			            },
			            "province_10": {
			                "firstWeight": 1.0,
			                "firstWeightPrice": 20.0,
			                "addedWeight": 1.0,
			                "addedWeightPrice": 10.0
			            }
			        },
			        "isEnableAddedWeight": true,
			        "addedWeight": 1.0,
			        "firstWeight": 1.0,
			        "addedWeightPrice": 5.0,
			        "firstWeightPrice": 13.0,
			        "free_factor": {
			            "province_1": [
			                {
			                    "condition_value": 3,
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

@openapi @chengdg
Scenario:2 通过商品ID调用单规格商品API,模板运费：首重+特殊地区
	When 给供货商选择运费配置::weapp
		"""
		{
			"supplier_name": "供货商1",
			"postage_name": "申通"
		}
		"""
	Then aini获取'商品1-1'的商品详情
		"""
			{
				"name": "商品1-1",
				"price": 50.00,
				"weight": 1.0,
				"image": "http://chaozhi.weizoom.comlove.png",
				"stocks": 100,
				"detail": "商品1-1描述信息",
				"unified_postage_money": 0.0,
				"postage_type": "custom_postage_type",
				"supplier_postage_config": {
			        "special_factor": {
			            "province_1": {
			                "firstWeight": 1.0,
			                "firstWeightPrice": 20.0,
			                "addedWeight": 1.0,
			                "addedWeightPrice": 10.0
			            },
			            "province_10": {
			                "firstWeight": 1.0,
			                "firstWeightPrice": 20.0,
			                "addedWeight": 1.0,
			                "addedWeightPrice": 10.0
			            }
			        },
			        "isEnableAddedWeight": true,
			        "addedWeight": 1.0,
			        "firstWeight": 1.0,
			        "addedWeightPrice": 5.0,
			        "firstWeightPrice": 13.0
			    }
			}
		"""

@openapi @chengdg
Scenario:3 通过商品ID调用单规格商品API,模板运费：首重+包邮
	When 给供货商选择运费配置::weapp
		"""
		{
			"supplier_name": "供货商1",
			"postage_name": "圆通"
		}
		"""
	Then aini获取'商品1-1'的商品详情
		"""
			{
				"name": "商品1-1",
				"price": 50.00,
				"weight": 1.0,
				"image": "http://chaozhi.weizoom.comlove.png",
				"stocks": 100,
				"detail": "商品1-1描述信息",
				"unified_postage_money": 0.0,
				"postage_type": "custom_postage_type",
				"supplier_postage_config": {
			        "isEnableAddedWeight": true,
			        "addedWeight": 1.0,
			        "firstWeight": 1.0,
			        "addedWeightPrice": 5.0,
			        "firstWeightPrice": 13.0,
			        "free_factor": {
			            "province_1": [
			                {
			                    "condition_value": 3,
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

@openapi @chengdg
Scenario:4 通过商品ID调用单规格商品API,模板运费：只有首重
	When 给供货商选择运费配置::weapp
		"""
		{
			"supplier_name": "供货商1",
			"postage_name": "顺丰"
		}
		"""
	Then aini获取'商品1-1'的商品详情
		"""
			{
				"name": "商品1-1",
				"price": 50.00,
				"weight": 1.0,
				"image": "http://chaozhi.weizoom.comlove.png",
				"stocks": 100,
				"detail": "商品1-1描述信息",
				"unified_postage_money": 0.0,
				"postage_type": "custom_postage_type",
				"supplier_postage_config": {
			        "special_factor": {},
			        "isEnableAddedWeight": true,
			        "addedWeight": 0.0,
			        "firstWeight": 0.1,
			        "addedWeightPrice": 0.0,
			        "firstWeightPrice": 10.0,
			        "free_factor": {}
			    } 
			}
		"""

@openapi @chengdg
Scenario:5 通过商品ID调用单规格商品API,统一运费
	Then aini获取'商品2-1'的商品详情
		"""
			{
				"name": "商品2-1",
				"price": 10.00,
				"weight": 1.0,
				"image": "http://chaozhi.weizoom.comlove.png",
				"stocks": 100,
				"detail": "商品1-2描述信息",
				"unified_postage_money": 10.0,
				"postage_type": "unified_postage_type",
				"supplier_postage_config": {}
			}
		"""

@openapi @chengdg
Scenario:6 通过商品ID调用单规格商品API,免运费
	Then aini获取'商品3-1'的商品详情
		"""
			{
				"name": "商品3-1",
				"price": 10.00,
				"weight": 1.0,
				"image": "http://chaozhi.weizoom.comlove.png",
				"stocks": 100,
				"detail": "商品1-2描述信息",
				"unified_postage_money": 0.0,
				"postage_type": "unified_postage_type",
				"supplier_postage_config": {}
			}
		"""

Scenario:7 供货商修改单规格商品后，aini通过商品ID调用单规格商品API，获得修改后单规格商品详情
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
			"weight": 1.0,
			"image": "http://chaozhi.weizoom.comlove.png",
			"stocks": 101,
			"detail": "商品2描述信息"
		}
		"""	
	Then aini获取'商品1-1'的商品详情
		"""
			{
				"name": "商品1-1",
				"price": 50.01,
				"weight": 1.0,
				"image": "http://chaozhi.weizoom.comlove.png",
				"stocks": 101,
				"detail": "商品2描述信息",
				"postage":[{
					"postage":10.0,
					"condition_money": 100.0
				}]
			}
		"""
