#author:徐梓豪 2016-09-18
Feature:普通账号查看应用列表
"""
1.激活应用后查看列表
2.被驳回后查看列表
3.被通过后查看列表
"""
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
Scenario:1 激活应用后查看列表
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

@poseidon	
Scenario:2 应用被驳回后查看列表
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

	Given manager登录系统
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |statute|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改| 

	When manager驳回申请
		"""
		{
		"account_main":"爱伲咖啡",
		"reason":"ip地址不合法"
		}
		"""
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |statute|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改| 

	Given aini使用密码213456登录系统
	Then aini查看应用列表
		|application_name|    app_id    |   app_secret   |   statute    |
		|    默认应用    |激活后自动生成| 激活后自动生成 |    已驳回    |


@poseidon	
Scenario:3 应用通过后查看列表
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

	Given manager登录系统
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |statute|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |确认通过/驳回修改| 

	When manager确认通过
		"""
		{
		"account_main":"爱伲咖啡"
		}
		"""
	Then manager查看应用审核列表
		|account_main|application_name|     appid    |   appsecret  |dev_name|mob_number |  email_address  | ip_address | interface_address    |statute|   operation   |
		|  爱伲咖啡  |  默认应用      |审核后自动生成|审核后自动生成|爱伲咖啡|13813984405|ainicoffee@qq.com|192.168.1.3|http://192.168.0.130|待审核 |暂停使用| 

	Given aini使用密码213456登录系统
	Then aini查看应用列表
		|application_name|    app_id    |   app_secret   |   statute    |
		|    默认应用    |   3565989    | sd124wr45sfds  |    已启用    |
