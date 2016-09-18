author:徐梓豪 2016-09-14
feature:普通账号激活应用
#appid和appsecret会自动生成

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
@poseidon
Scenario:1 普通账号激活应用
	Given aini使用密码123456登录系统
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
