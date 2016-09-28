#author:徐梓豪 2016-09-18
Feature:管理员审核应用
"""
1.管理员驳回申请
2.管理员同意申请
3.被驳回再次修改
4.激活后暂停停用
"""
Background:
	Given manager登录开放平台系统
	When manager创建开放平台账号
		"""
		[{
		"account_name":"aini",
		"password":"123456",
		"account_main":"爱伲咖啡",
		"isopen":"是"
		},{
		"account_name":"naike",
		"password":"123456",
		"account_main":"耐克男鞋",
		"isopen":"是"
		},{
		"account_name":"zhouheiya",
		"password":"123456",
		"account_main":"周黑鸭",
		"isopen":"是"
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
	Then aini查看应用列表
		|application_name|    app_id    |   app_secret   |   status    |
		|    默认应用    |    随机生成  | 随机生成 |    待审核    |

	Given naike使用密码123456登录系统
	Then naike激活应用
		"""
		[{
		"dev_name":"耐克男鞋",
		"mobile_num":"13813984406",
		"e_mail":"nkshoes@qq.com",
		"ip_address":"192.168.1.4",
		"interface_address":"http://192.168.0.170"
		}]
		"""
	Then naike查看应用列表
		|application_name|    app_id    |   app_secret   |   status    |
		|    默认应用    |随机生成| 随机生成 |    待审核    |
	Given zhouheiya使用密码123456登录系统
	Then zhouheiya激活应用
		"""
		[{
		"dev_name":"周黑鸭",
		"mobile_num":"13813984410",
		"e_mail":"duck@qq.com",
		"ip_address":"192.168.1.23",
		"interface_address":"http://192.168.0.233"
		}]
		"""
	Then zhouheiya查看应用列表
		|application_name|    app_id    |   app_secret   |   status    |
		|    默认应用    |随机生成| 随机生成 |    待审核    |

@poseidon @application @account @hj
Scenario:1 管理员驳回申请
	Given manager登录开放平台系统
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改| 
		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|待审核 |确认通过/驳回修改| 
		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 

	When manager驳回申请
		"""
		[{
		"account_main":"耐克男鞋",
		"reason":"ip地址不合法"
		}]
		"""
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改|
		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|已驳回 |驳回原因:ip地址不合法| 
		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 

	Given naike使用密码123456登录系统
	Then naike查看应用列表
		|application_name|    app_id    |   app_secret   |   status    |
		|    默认应用    |随机生成| 随机生成 |    已驳回    |

@poseidon @application @account @hj
Scenario:2 管理员同意申请
	Given manager登录开放平台系统
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改|
		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|待审核 |确认通过/驳回修改| 
		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 
	When manager同意申请
		"""
		[{
		"account_main":"爱伲咖啡"
		}]
		"""
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
		|  爱伲咖啡  |  默认应用      |   随机生成    |随机生成 |爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|已启用 |    暂停停用   |
		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|待审核 |确认通过/驳回修改| 
		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 

	Given aini使用密码123456登录系统
	Then aini查看应用列表
		|application_name|    app_id    |   app_secret   |   status    |
		|    默认应用    |   随机生成    | 随机生成  |    已启用    |

# @poseidon @application
# Scenario:3 被驳回再次修改
# 	Given manager登录开放平台系统
# 	Then manager查看应用审核列表
# 		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
# 		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改| 
# 		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|待审核 |确认通过/驳回修改| 
# 		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 

# 	When manager驳回申请
# 		"""
# 		{
# 		"account_main":"耐克男鞋",
# 		"reason":"ip地址不合法"
# 		}
# 		"""
# 	Then manager查看应用审核列表
# 		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
# 		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改|
# 		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|已驳回 |驳回原因:ip地址不合法| 
# 		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改|

# 	Given naike使用密码213456登录系统
# 	Then naike查看应用列表
# 		|application_name|    app_id    |   app_secret   |   status    |
# 		|    默认应用    |激活后自动生成| 激活后自动生成 |    已驳回    |

# 	Then naike重新修改并激活应用
# 		"""
# 		{
# 			"dev_name":"耐克男鞋",
# 			"mobile_num":"13813984406",
# 			"e_mail":"nkshoes@qq.com",
# 			"ip_address":"192.168.1.28",
# 			"interface_address":"http://192.168.0.170"
# 		}
# 		"""
# 	Then naike查看应用列表
# 		|application_name|    app_id    |   app_secret   |   status    |
# 		|    默认应用    |激活后自动生成| 激活后自动生成 |    待审核    |

# 	Then manager查看应用审核列表
# 		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
# 		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改| 
# 		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.28|http://192.168.0.170|待审核 |确认通过/驳回修改| 
# 		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 

@poseidon @application @account @hj
Scenario:4 激活后暂停停用
	Given manager登录开放平台系统
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改|
		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|待审核 |确认通过/驳回修改| 
		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 
	When manager同意申请
		"""
		[{
		"account_main":"爱伲咖啡"
		}]
		"""
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
		|  爱伲咖啡  |  默认应用      |   随机生成    |随机生成 |爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|已启用 |    暂停停用   |
		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|待审核 |确认通过/驳回修改| 
		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 

	Given aini使用密码123456登录系统
	Then aini查看应用列表
		|application_name|    app_id    |   app_secret   |   status    |
		|    默认应用    |   随机生成    | 随机生成  |    已启用    |
	Given manager登录开放平台系统
	When manager暂停停用应用
		"""
		[{
			"account_main":"爱伲咖啡"
		}]
		"""
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |status|   operation   |
		|  爱伲咖啡  |  默认应用      |   随机生成    |随机生成     |爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130   |已停用 |      启用     |
		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984406|  nkshoes@qq.com |192.168.1.4|http://192.168.0.170|待审核 |确认通过/驳回修改| 
		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|周黑鸭|13813984410|    duck@qq.com  |192.168.1.23|http://192.168.0.233|待审核 |确认通过/驳回修改| 


