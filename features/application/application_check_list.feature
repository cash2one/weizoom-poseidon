#author:徐梓豪 2016-09-18
Feature:管理员查看应用审核列表

Background:
	Given manager登录开放平台系统
	When manager创建开放平台账号
		"""
		[{
		"acoount_name":"aini",
		"password":"123456",
		"account_main":"爱伲咖啡",
		"isopen":"是"
		},{
		"acoount_name":"naike",
		"password":"123456",
		"account_main":"耐克男鞋",
		"isopen":"是"
		},{
		"acoount_name":"zhouheiya",
		"password":"123456",
		"account_main":"周黑鸭",
		"isopen":"是"
		}]
		"""
	Given aini使用密码123456登录系统
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
		|    默认应用    |激活后自动生成| 激活后自动生成 |    待审核    |

	Given nake使用密码123456登录系统
	Then nake激活应用
		"""
		{
		"dev_name":"耐克男鞋",
		"mobile_num":"13813984406",
		"e_mail":"nkshoes@qq.com",
		"ip_address":"192.168.1.4",
		"interface_address":"http://192.168.0.170"
		}
		"""
	Then naike查看应用列表
		|application_name|    app_id    |   app_secret   |   statute    |
		|    默认应用    |激活后自动生成| 激活后自动生成 |    待审核    |
	Given zhouheiya使用密码123456登录系统
	Then zhouheiya激活应用
		"""
		{
		"dev_name":"周黑鸭",
		"mobile_num":"13813984410",
		"e_mail":"duck@qq.com",
		"ip_address":"192.168.1.23",
		"interface_address":"http://192.168.0.233"
		}
		"""
	Then zhouheiya查看应用列表
		|application_name|    app_id    |   app_secret   |   statute    |
		|    默认应用    |激活后自动生成| 激活后自动生成 |    待审核    |

@poseidon @application
Scenario:1 管理员查看应用审核列表
	Given manager登录系统
	When manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3
		|http://192.168.0.130| 
		|  耐克男鞋  |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984405|  nkshoes@qq.com |192.168.1.4
		|http://192.168.0.170| 
		|   周黑鸭   |  默认应用      |审核后自动生成|审核后自动生成|耐克男鞋|13813984410|    duck@qq.com  |192.168.1.23
		|http://192.168.0.233| 


