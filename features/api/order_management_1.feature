# __author__ : "王丽"

Feature: 自营平台订单管理-云商通管理系统后台-单个供应商商品订单-微信支付+优惠券(不满足满额包邮)；退现金优惠券
"""
	一、后台订单列表
		自营平台单或者多供货商品商品的订单，支付之前不拆单，支付之后拆单

		1 所有订单都按照母子订单的方式展示
			1）待支付的订单，【订单状态】显示在合并的订单状态对应处'待支付'
			2）支付之后的订单，【订单状态】和【操作按钮】拆分到各个子订单
			3）子订单状态和对应的按钮
				母订单状态         操作按钮
				待支付             支付、取消订单

				子订单状态         操作按钮
				已取消             无
				待发货             发货、申请退款
				已发货             标记完成、修改物流、申请退款
				已完成             申请退款
				退款中             无  （在财务审核中有按钮'退款完成'）
				退款完成           无

				备注特殊订单
				团购订单
				1） 组团成功的订单
					订单状态           操作按钮
					待发货             发货
					已发货             标记完成
					已完成             无
				2） 没有组团成功，自动退款
					订单状态           操作按钮
					退款中             无（在财务审核中无按钮）
					退款成功           无

			4）母订单的状态根据子订单的状态按照如下规则定义
				按照订单状态优先级排序规则，取优先级最低的子订单状态显示
				订单状态优先级由低到高排序为：
				待支付->待发货->已发货->退款中->已完成->退款完成->已取消
		2 对子订单进行退款
			1）某个子订单点击【申请退款】，弹出退款录入的界面
				（1）展示出当前订单应退金额：
					即：“退款录入，当前订单应退￥50.00”（即子订单的商品总金额(按照商品的售价（限时抢购、会员价）计算)+运费）
					    “母订单支付金额：现金￥30.00+微众卡￥20.00+优惠券￥15.00+积分￥10.00=￥75.00”（各种支付方式对应金额）
				（2）运营人员需要输入当前订单退款的各个方式对应的金额
					"现金"：输入的金额必须为大于等于零的整数或者小数（保留两位小数）；不能大于母订单的现金支付金额减去子订单退款的退款现金金额,否则给出红色提示'最多可退XX.XX元'
					"微众卡"：输入的金额必须为大于等于零的整数或者小数（保留两位小数）；不能大于当前母订单的微众卡支付金额减去子订单退款的退款的微众卡的金额,否则给出红色提示'最多可退XX.XX元'
					"优惠券"：输入的金额必须为大于等于零的整数或者小数（保留两位小数）；
					"积分"：积分比例按照系统当前的抵扣比例展示，输入积分值，只能是零或正整数，自动按照现在的积分比例计算出抵扣金额
				（3）当母订单中已经有订单的退款录入时，再对其他子订单操作退款时，展示添加【已退款金额】详情；录入时，现金、微众卡可退金额需要扣除“已退款金额”的相应部分
				"已退款金额"：现金￥15.00+微众卡￥15.00+优惠券￥15.00+积分￥5.00=￥50.00
				（4）"共计"：XX.XX元
				需要根据已填写的四项金额实时计算变化；当"共计金额"与"退款录入，当前订单应退"相等时，才可以提交退款申请；否则点击提交后提示“退款金额不等于XX.XX元”
		3 母订单【实付金额】数据，需减掉退款完成的子订单退掉的相应金额（即现金+微众卡金额）
		4 订单状态为"退款中"、"退款完成"的子订单，在订单状态后给出详情图标，鼠标悬停时展示其退款详细信息；
			退款详情信息的展示方式：
			1）所有退款项的金额都不为零；如：现金￥50.00+微众卡￥20.00+优惠券￥10.00+积分￥5.00=￥85.00
			2）某种退款项金额为0时，不显示该退款方式；如：现金￥10.00+优惠券￥5.20=￥15.20
			3）只有一种退款项时，直接显示退款项及金额，如：优惠券￥20.00

	二、后台订单详情
		1 母订单基本信息
			订单编号：母订单的订单编号
			订单状态：母订单的订单状态
			按钮：只有母订单的订单状态为'待支付'的时候显示按钮"支付"、"取消订单"
			订单时间轨迹：母订单订单状态变化的时间轨迹
				备注：这里的轨迹可能比较多，显示不下的时候怎么显示？？

		2 买家信息
			1）收货信息
				收货人：
				联系电话：
				收货地址：
				买家留言：
			2）发票信息
				发票抬头：没有发票抬头显示" "
			3）供货商备注
				点击编辑按钮可以添加供货商备注

		3 物流信息
			分页签显示不同子订单的不同供货商的物流信息，页签名为同步供货商名称
			物流公司名称：发货时填写的物流公司名称
			运单号：发货时填写的运单号
			物流信息展示在下面

		4 在物流信息后的最后一个页签"订单操作日志"
			时间：精确到秒
			操作：买家和后台对订单的每步操作；不同供货商的操作展示成如下格式"XXX-供货商名"
			操作人：客户或者供货商名

		5 订单信息
			1)支付方式：订单的支付方式
			2)供货商：商品订单对应的供货商名称
			3)商品信息：商品名称和商品图片
			4)单价(元)/数量：商品的单价（商品的原始单价，不包含任何促销活动）和购买的数量
			5)单品优惠：显示使用单品积分"XX积分，抵扣XX.XX元"
						显示限时抢购优惠"直降XX.XX元"
			6)运费：订单的运费
			7)订单状态：分别显示各个子订单的订单状态；
					"退款中"和"退款完成"的订单的订单状态后显示查看图标，
					移动到查看图标显示退款的详情"现金￥30.00+微众卡￥0.00+优惠券￥15.00+积分￥10.00=￥55.00"
			8)整单优惠：显示优惠券优惠"多商品劵 :XX.XX（优惠券券码）"
						显示使用全店积分"XX积分，抵扣XX.XX"

			9)微众卡支付金额：显示微众卡支付金额"XX.XX"和查看图标，移动到查看图标，显示卡号
				有退款完成的，扣减到退款完成的订单对应退的微众卡的金额
			10)共计商品：XX件；商品的个数总和
			11)商品金额：￥XX.XX；Σ商品单价*商品数量
			12)运费：+￥XX.XX（没有运费的时候显示成0.00）
			13)优惠金额：-￥XX.XX；（没有优惠的时候不显示）
			14)支付金额："现金￥XX.XX+微众卡￥XX.XX=￥XX.XX"；没有的项直接显示成0.00；
				扣减掉退款完成的订单对应退的现金和微众卡的金额
			15)原始支付金额："现金￥XX.XX+微众卡￥XX.XX=￥XX.XX"；没有的项直接显示成0.00；
				订单最开始支付的现金和微众卡的金额
			15)已退款金额："现金￥30.00+微众卡￥0.00+优惠券￥15.00+积分￥10.00=￥55.00";
							有退款完成的子订单，实付金额计算栏下方展示已退款金额合计详情

	三、手机端订单列表
		1 展示母订单状态
		2 当有子订单状态为“退款完成”时，“实付款”的数据应该扣减掉子订单相应退的现金金额（即支付的现金金额）

	四、手机端订单详情
		1 母订单基本信息
			1）母订单的订单状态
			2）订单号：母订单的订单号
			3）收货人：收货人姓名、电话、地址
		2 订单商品信息
			1）供货商名称
			2）本供货商子订单状态，放在供货商名称后，右对齐
			3）购买供货商的商品列表
				商品信息：商品图片（活动商品标记：积分抵扣、优惠券、赠品）、商品名称、商品售价（原价、限时抢购价、会员价）、购买数量
				运费：运费信息和金额
				物流信息：没有物流信息时显示"暂无物流信息"
			4）支付方式：显示整个母订单的支付方式
			5）商品金额：￥XX.XX；Σ商品售价*购买数量（即商品售价指的是商品的限时抢购和会员价）
			6）运费：+￥XX.XX；包邮时显示0.00
			7）优惠抵扣：-￥XX.XX；包含积分、优惠券；没有时不显示此项
			8）微众卡抵扣：-￥XX.XX；没有时不显示此项；
				显示的始终是对出付的微众卡的金额，不扣减退款的微众卡的金额
			9）实退金额：-￥XX.XX；
						当有子订单状态为“退款完成”时，结算栏需添加【实退金额】，展示数据为录入退款的相应现金的金额总计；为0时（即全部退微众卡或优惠券或积分），也展示，数据展示0.00就可以；
			10）实付金额：￥XX.XX；=商品金额+运费-优惠抵扣-微众卡抵扣-实退金额
			11）下单时间：精确到秒

"""
Background:
	Given 重置'apiserver'的bdd环境
	Given zy1登录系统
	When zy1已添加支付方式
		"""
		[{
			"type": "微信支付",
			"is_active": "启用"
		}]
		"""

	#创建供货商、设置供货商运费、同步商品到自营平台
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
					"name": "商品1-1",
					"promotion_title": "商品1-2促销",
					"purchase_price": 40.00,
					"price": 50.00,
					"weight": 1,
					"image": "love.png",
					"stocks": 100,
					"detail": "商品1-1描述信息"
				}
				"""
	#自营平台从商品池上架商品
		Given zy1登录系统
		When zy1上架商品池商品"商品1-1"

	#创建优惠券活动
	When zy1添加优惠券规则
		"""
		[{
			"name": "全店通用券1",
			"money": 10.00,
			"limit_counts": "无限",
			"count": 5,
			"start_date": "2013-10-10",
			"end_date": "1天后",
			"description":"使用说明",
			"coupon_id_prefix": "coupon1_id_"
		}]
		"""

	Given bill关注zy1的公众号

	Given zy1登录系统
	When zy1创建优惠券发放规则发放优惠券
		"""
		{
			"name": "全店通用券1",
			"count": 1,
			"members": ["bill"]
		}
		"""

	When bill访问zy1的webapp::apiserver
	When bill购买zy1的商品::apiserver
		"""
		{
			"order_id":"001",
			"date":"2016-01-01",
			"ship_name": "bill",
			"ship_tel": "13811223344",
			"ship_area": "北京市 北京市 海淀区",
			"ship_address": "泰兴大厦",
			"pay_type": "微信支付",
			"coupon": "coupon1_id_1",
			"products":[{
				"name":"商品1-1",
				"price":50.00,
				"count":1,
				"postage": 10.00
			}],
			"postage": 10.00,
			"customer_message": "bill的订单备注"
		}
		"""
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

@refund @order
Scenario:1 单个供应商商品订单-待支付
	#待支付订单
		#后台订单列表

	Given aini登录系统:管理系统
	Then aini查看订单列表
			"""
			[{
				"order_no":"001",
				"products":[{
					"name":"商品1-1",
					"price":50.00,
					"count":1
				}],
				"methods_of_payment":"微信支付",
				"order_time":"2016-01-01 00:00:00",
				"save_money": 10.00,
				"buyer":"bill",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_address": "北京市 北京市 海淀区 泰兴大厦",
				"invoice":"",
				"final_price": 50.00,
				"postage": 10.00,
				"status":"待支付",
				"actions": ["支付","取消订单"]
			}]
			"""

	#后台订单详情
	Then aini获得自营订单'001'
			"""
			{
				"order_no":"001",
				"status":"待支付",
				"actions": ["支付","取消订单"],
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
						"supplier":"供货商1",
						"price":50.00,
						"count":1
					}],
					"postage": 10.00,
					"status":"待支付"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"save_money": 10.00,
				"cash":50.00,
				"weizoom_card": 0.00,
				"final_price": 50.00
			}
			"""
		Then aini能获得订单'001'操作日志
			| action                  | operator |
			| 下单                    | 客户     |

@refund @order
Scenario:2 单个供应商商品订单-待发货
	#待发货订单
		When bill使用支付方式'微信支付'进行支付订单'001'于2016-01-02 10:00:00::apiserver

		#后台订单列表
		Given aini登录系统
		Then aini获得自营订单列表
			"""
			[{
				"order_no":"001",
				"methods_of_payment":"微信支付",
				"order_time":"2016-01-01 00:00:00",
				"payment_time":"2016-01-02 10:00:00",
				"save_money": 10.00,
				"buyer":"bill",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_address": "北京市 北京市 海淀区 泰兴大厦",
				"invoice":"",
				"final_price": 50.00,
				"postage": 10.00,
				"status":"待发货",
				"group":[{
					"order_no":"001-供货商1",
					"supplier":"供货商1",
					"products":[{
						"name":"商品1-1",
						"price":50.00,
						"count":1
					}],
					"status":"待发货",
					"actions": ["发货","申请退款"]
				}]
			}]
			"""

		#后台订单详情
		Then aini获得自营订单'001'
			"""
			{
				"order_no":"001",
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
						"name":"商品1-1",
						"supplier":"供货商1",
						"price":50.00,
						"count":1
					}],
					"postage": 10.00,
					"status":"待发货"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"save_money": 10.00,
				"cash":50.00,
				"weizoom_card": 0.00,
				"final_price": 50.00
			}
			"""
		Then aini能获得订单'001'操作日志
			| action                  | operator |
			| 下单                    | 客户     |
			| 支付                    | 客户     |

@refund @order
Scenario:3 单个供应商商品订单-退款中
	#退款中
		When bill使用支付方式'微信支付'进行支付订单'001'于2016-01-02 10:00:00::apiserver

		Given aini登录系统
		When aini申请退款'自营订单'001-供货商1'
			"""
			{
				"cash":10.00,
				"weizoom_card":0.00,
				"coupon_money":50.00,
				"intergal":0,
				"intergal_money":0.00
			}
			"""

		#后台订单列表
		Then aini获得自营订单列表
			"""
			[{
				"order_no":"001",
				"methods_of_payment":"微信支付",
				"order_time":"2016-01-01 00:00:00",
				"payment_time":"2016-01-02 10:00:00",
				"save_money": 10.00,
				"buyer":"bill",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_address": "北京市 北京市 海淀区 泰兴大厦",
				"invoice":"",
				"final_price": 50.00,
				"postage": 10.00,
				"status":"退款中",
				"group":[{
					"order_no":"001-供货商1",
					"supplier":"供货商1",
					"products":[{
						"name":"商品1-1",
						"price":50.00,
						"count":1
					}],
					"status":"退款中",
					"refund_details":{
						"cash": 10.00,
						"weizoom_card": 0.00,
						"coupon_money": 50.00,
						"integral_money": 0.00
					},
					"actions": []
				}]
			}]
			"""

		#后台订单详情
		Then aini获得自营订单'001'
			"""
			{
				"order_no":"001",
				"status":"退款中",
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
						"supplier":"供货商1",
						"price":50.00,
						"count":1
					}],
					"postage": 10.00,
					"status":"退款中"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"save_money": 10.00,
				"cash":50.00,
				"weizoom_card": 0.00,
				"final_price": 50.00
			}
			"""
		Then aini能获得订单'001'操作日志
			| action                  | operator |
			| 下单                    | 客户     |
			| 支付                    | 客户     |
			| 退款                    | zy1      |

@refund @order
Scenario:4 单个供应商商品订单-退款成功
	#退款完成
		When bill使用支付方式'微信支付'进行支付订单'001'于2016-01-02 10:00:00::apiserver

		Given aini登录系统
		When aini申请退款'自营订单'001-供货商1'
			"""
			{
				"cash":10.00,
				"weizoom_card":0.00,
				"coupon_money":50.00,
				"intergal":0,
				"intergal_money":0.00
			}
			"""
		When aini通过财务审核'退款成功'自营订单'001-供货商1'

		#后台订单列表
		Then aini获得自营订单列表
			"""
			[{
				"order_no":"001",
				"methods_of_payment":"微信支付",
				"order_time":"2016-01-01 00:00:00",
				"payment_time":"2016-01-02 10:00:00",
				"save_money": 10.00,
				"buyer":"bill",
				"ship_name":"bill",
				"ship_tel":"13811223344",
				"ship_address": "北京市 北京市 海淀区 泰兴大厦",
				"invoice":"",
				"final_price": 40.00,
				"postage": 10.00,
				"status":"退款成功",
				"group":[{
					"order_no":"001-供货商1",
					"supplier":"供货商1",
					"products":[{
						"name":"商品1-1",
						"price":50.00,
						"count":1
					}],
					"status":"退款成功",
					"refund_details":{
						"cash": 10.00,
						"weizoom_card": 0.00,
						"coupon_money": 50.00,
						"integral_money": 0.00
					},
					"actions": []
				}]
			}]
			"""

		#后台订单详情
		Then aini获得自营订单'001'
			"""
			{
				"order_no":"001",
				"status":"退款成功",
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
						"supplier":"供货商1",
						"price":50.00,
						"count":1
					}],
					"postage": 10.00,
					"status":"退款成功"
				}],
				"products_count":1,
				"total_price": 50.00,
				"postage": 10.00,
				"save_money": 10.00,
				"refund_money":10.00,
				"cash":40.00,
				"weizoom_card": 0.00,
				"final_price": 40.00,
				"original_cash":50.00,
				"original_weizoom_card":0.00,
				"original_final_price":50.00,
				"refund_details":{
					"cash": 10.00,
					"weizoom_card": 0.00,
					"coupon_money": 50.00,
					"integral_money": 0.00
				}
			}
			"""
		Then aini能获得订单'001'操作日志
			| action                  | operator |
			| 下单                    | 客户     |
			| 支付                    | 客户     |
			| 退款                    | aini     |
			| 退款完成                | aini     |
