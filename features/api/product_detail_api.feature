# __author__ : "BenChi" 2016923

Feature: 提供商品详情的API
"""
	一、单规格商品
	二、供货商对单规格商品修改（该场景应该在商品管理的feature场景中验证，无需在api中验证）

"""
Background:
	Given 重置'apiserver'的bdd环境
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
					"detail": "商品1-1描述信息"
				}
				"""
		#自营平台从商品池上架商品
			Given zy1登录系统::weapp
			When zy1上架商品池商品"商品1-1"::weapp
			
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

@chengdg	
Scenario:1 通过商品ID调用单规格商品API

	Then aini获取'000001'的商品详情
		"""
			{
				"name": "商品1-1",
				"price": 50.00,
				"weight": 1.0,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"stocks": 100,
				"detail": "商品1-1描述信息",
				"postage":[{
					"postage":10.0,
					"condition_money": 100.0
				}]
			}
		"""

Scenario:2 供货商修改单规格商品后，jd通过商品ID调用单规格商品API，获得修改后单规格商品详情
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
	Then aini获取'000001'的商品详情
		"""
			{
				"name": "商品1-1",
				"price": 50.01,
				"weight": 1,
				"image": "http://chaozhi.weizoom.comhttp://chaozhi.weizoom.comlove.png",
				"stocks": 101,
				"detail": "商品2描述信息",
				"postage":[{
					"postage":10,
					"condition_money": 100
				}]
			}
		"""
