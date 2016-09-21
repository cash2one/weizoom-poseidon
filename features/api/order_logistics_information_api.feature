author:徐梓豪 2016-09-20
Feature: 测试订单详情API的场景
	Given manager登录系统:管理系统
	When manager创建运营账号
		"""
		{
		"account_type":"运营",
		"account_name":"运营部门",
		"login_account":"yunying",
		"password":123456,
		"ramarks":"运营部门"
		}
		"""
	Given yunying登录系统:管理系统
	When yunying添加分类
		"""
		{
		"head_classify":"无",
		"classify_name":"电子数码",
		"comments":"1"
		},{
		"head_classify":"无",
		"classify_name":"生活用品",
		"comments":"1"
		},{
		"head_classify":"电子数码",
		"classify_name":"手机",
		"comments":""
		},{
		"head_classify":"电子数码",
		"classify_name":"平板电脑",
		"comments":""
		},{
		"head_classify":"电子数码",
		"classify_name":"耳机",
		"comments":""
		},{
		"head_classify":"生活用品",
		"classify_name":"零食",
		"comments":""
		},{
		"head_classify":"生活用品",
		"classify_name":"肥皂",
		"comments":""
		},{
		"head_classify":"生活用品",
		"classify_name":"清洗用品,
		"comments":""
		}
		"""
	Given manager登录系统:管理系统
	When manager创建账号
		"""
		[{
			"account_type":"体验客户",
			"company_name":"爱昵咖啡有限责任公司",
			"product_style":{
					"电子数码"，
					"生活用品"
					},
			"shop_name":"爱昵咖啡",
			"manage_type":"休闲食品",
			"purchase_type":"固定底价",
			"connect_man":"aini",
			"mobile_number":"13813985506",
			"login_account":"aini",
			"password":"123456",
			"settlement_time":"15天",
			"valid_time":"2016-07-15"至"2017-12-31",
			"ramarks":"爱昵咖啡客户体验账号"
		}]
		"""

	Given aini登录系统:管理系统
	When aini添加规格
		"""
		[{
		"standard_name":"尺码",
		"show_type":"文字",
		"standard":{
					"M","X","XL","XXL","XXXL"
					}
		},{
		"standard_name":"颜色",
		"show_type":"文字",
		"standard":{
					"红","黄","蓝","黑"
					}
		}]
		"""

	When aini添加商品
		"""
		[{
		"first_classify":"生活用品",
		"second_classify":"零食",
		"product_name": "武汉鸭脖",
		"title":"武汉鸭脖",
		"introduction": "这是一种很好吃的鸭脖"
		"standard_promotion":"否",
		"price":10.00,
		"setlement_price":8.00,
		"weight":0.23,
		"repertory":"500.00",
		"picture":"",
		"description":"周黑鸭 鲜卤鸭脖 230g/袋 办公室休闲零食 肉干小食"
		},{
		"first_classify":"电子数码",
		"second_classify":"耳机",
		"product_name": "耐克男鞋",
		"title":"耐克男鞋，耐穿耐磨",
		"standard_promotion":"是",
		"standard":{
					"standard_name":"颜色",
					"standard":"黑色","红色"
					},{
					"standard_name":"尺码",
					"standard":"X,XL"
					},
		"standard_price":{
					|standard_1|standard_2|purchase_price|sale_price|weight|stock_number|product_id|
					|   黑色   |     X    |     14.90    |   29.00  | 0.50 |   2500.00  |    001   |
					|   黑色   |    XL    |     14.90    |   29.00  | 0.50 |   2000.00  |    002   |    
					|   红色   |     X    |     14.90    |   29.00  | 0.50 |   1000.00  |    003   |
					|   红色   |    XL    |     14.90    |   29.00  | 0.50 |   1300.00  |    004   | 
					},
		"area_setting":""
		},{
		"first_classify":"电子数码",
		"second_classify":"平板电脑",
		"shop_name": "ipad",
		"title":"苹果平板",
		"standard_promotion":"否",
		"price":3000.00,
		"setlement_price":2500.00,
		"weight":2.00,
		"repertory":"500.00",
		"picture":"",
		"description":"苹果平板，大屏看电视"
		}
		}]
		"""
	Then aini能获得商品列表
		|  name   | set_price |sale_price| sales |   creat_time   | status |
		|武汉鸭脖 |   10.00   |    8.00  | 0.00  |2016-07-25 16:30| 未上架 |
		|耐克男鞋 |   14.90   |   29.00  | 0.00  |2016-07-25 16:30| 未上架 |
		|  ipad   |  3000.00  |  2500.00 | 0.00  |2016-08-22 11:03| 未上架 |

	Given manager登录系统:开放平台
	When manager创建账号
		"""
		{
		"acoount_name":"aini",
		"password":"123456",
		"account_main":"爱伲咖啡",
		"isopen":"是"
		}
		"""

	Given aini使用密码123456登录系统:开放平台
	When aini查看应用列表
		|application_name|    app_id    |   app_secret   |   statute    |
		|    默认应用    |激活后自动生成| 激活后自动生成 |    未激活    |
	Then aini激活应用
		"""
		{
		"dev_name":"爱伲咖啡",
		"mobile_num":"13813984405",
		"e_mail":"ainicoffee@qq.com",
		"ip_address":"192.168.1.3",
		"interface_address":"http://192.168.0.130"
		}
		"""
	Then aini查看应用列表
		|application_name|    app_id    |   app_secret   |   statute    |
		|    默认应用    |55550bb005370f|20160913b13s057b|    待审核    |

	Given manager登录系统:开放平台
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |statute|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3
		|http://192.168.0.130|待审核 |确认通过/驳回修改|
	When manager同意申请
		"""
		{
		"account_main":"爱伲咖啡"
		}
		"""
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |statute|   operation   |
		|  爱伲咖啡  |  默认应用      |   3565989    |sd124wr45sfds |爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3
		|http://192.168.0.130|已启用 |    暂停停用   |
	Given aini登录系统:管理系统
	When aini添加商品
		"""
		[{
		"first_classify":"生活用品",
		"second_classify":"零食",
		"product_name": "武汉鸭脖",
		"title":"武汉鸭脖",
		"introduction": "这是一种很好吃的鸭脖"
		"standard_promotion":"否",
		"price":10.00,
		"setlement_price":8.00,
		"weight":0.23,
		"repertory":"500.00",
		"picture":"",
		"description":"周黑鸭 鲜卤鸭脖 230g/袋 办公室休闲零食 肉干小食"
		},{
		"first_classify":"电子数码",
		"second_classify":"耳机",
		"product_name": "耐克男鞋",
		"title":"耐克男鞋，耐穿耐磨",
		"standard_promotion":"是",
		"standard":{
					"standard_name":"颜色",
					"standard":"黑色","红色"
					},{
					"standard_name":"尺码",
					"standard":"X,XL"
					},
		"standard_price":{
					|standard_1|standard_2|purchase_price|sale_price|weight|stock_number|product_id|
					|   黑色   |     X    |     14.90    |   29.00  | 0.50 |   2500.00  |    001   |
					|   黑色   |    XL    |     14.90    |   29.00  | 0.50 |   2000.00  |    002   |    
					|   红色   |     X    |     14.90    |   29.00  | 0.50 |   1000.00  |    003   |
					|   红色   |    XL    |     14.90    |   29.00  | 0.50 |   1300.00  |    004   | 
					},
		"area_setting":""
		},{
		"first_classify":"电子数码",
		"second_classify":"平板电脑",
		"shop_name": "ipad",
		"title":"苹果平板",
		"standard_promotion":"否",
		"price":3000.00,
		"setlement_price":2500.00,
		"weight":2.00,
		"repertory":"500.00",
		"picture":"",
		"description":"苹果平板，大屏看电视"
		}]
		"""
	Given yunying登录系统:管理系统
	When yunying同步商品'武汉鸭脖'
		"""
		{
		"synchronous_goods":"微众商城",
		"synchronous_goods":"微众家",
		"synchronous_goods":"微众白富美"
		}
		"""
	When yunying同步商品'耐克男鞋'
		"""
		{
		"synchronous_goods":"微众家",
		"synchronous_goods":"微众白富美"
		}
		"""
	Then yunying查看商品列表
		| goods_name | costumer_name |  product_style   |sales  |  status  |synchronous_platform|
		|  武汉鸭脖  |   爱伲咖啡    |  生活用品--零食  | 0.00  |  已同步  |微众商城,微众家,微众白富美|
		|  耐克男鞋  |   爱伲咖啡    |  电子数码--耳机  | 0.00  |  已同步  |微众家,微众白富美   |
		|    ipad    |   爱伲咖啡    |电子数码--平板电脑| 0.00  |  未同步  |					|

	Given jobs登录系统:weapp
	When jobs上架商品
		"""
		[{
		"name":"周黑鸭"
		},{
		"name":"耐克男鞋"
		}]
		"""
	When 微信用户在微商城中购买同步了的商品
		|	order_id	  | date       | consumer |    type   |businessman|   product | payment  | payment_method | freight |   price  | product_integral |  	 coupon  		| paid_amount |	weizoom_card 		| alipay | wechat | cash |      action       |  order_status   |
		|201609201000001  | 2016-09-22 | bill     |    购买   | 微众商城   | 武汉鸭脖  | 支付    | 支付宝         | 10      |   9.99   |      20.00       |                		|   199.80      |           		  |10.00 | 0      | 0    |    jobs,支付      |  待发货         |
		|201609201000002  | 2016-09-20 | tom      |    购买   | 微众家     | 耐克男鞋  | 支付    | 支付宝         | 15      |  298.00  |       1.00       |        				|         298.00   |       	          | 29.00| 0      | 0    |    jobs,支付      |  待发货         |

@poseidon @api_order
Scenairo:测试订单产生API的场景
	Given aini登录系统:管理系统
	Then aini查看订单列表
		|    order_id   |   date   | order_price | consumer | businessman | 
		|201609201000001|2016-09-22|    10.00    |   bill   |  微众商城   |
		|201609201000002|2016-09-20|    29.00    |   tom    |   微众家    |
	When aini发货
		"""
		{
		"order_id":"201609201000001",
		"logistics_company":"申通速递",
		"code":"10475926547"
		}
		"""

	When 访问api	
		"""
		{
		"order_id":"$order_id(201609201000001)$"
		}
		"""
	Then 获取返回值
		"""
		{
		"order_id":"201609201000001",
		"logistics_company":"申通速递",
		"code":"10475926547",
		"tracking_information":"已敛货"
		}
		"""
	When 访问api	
		"""
		{
		"order_id":"$order_id(201609201000002)$"
		}
		"""
	Then 获取返回值
		"""
		{
		"order_id":"201609201000002",
		"logistics_company":"",
		"code":""
		}
		"""