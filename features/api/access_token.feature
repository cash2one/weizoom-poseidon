#author:郭玉成 2016-09-28
Feature:获取accesstoken
"""
1.管理员创建开放平台账号
2.管理员编辑开放平台账号
3.管理员关闭开放平台账号
"""
Background:
	#同步商品到自营平台
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

@poseidon @access_token @bert
Scenario:1 openapi授权
	When aini获取access_token
