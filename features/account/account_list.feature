#author:徐梓豪 2016-09-14
Feature:管理员浏览账号列表

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
@poseidon
Scenario:1 管理员浏览账号列表
	
	Then manager查看账号列表
		| account_name |  main_name  |   create_time  |    state    |   operation  |
		|     aini     |  爱伲咖啡   |2016-09-14 12:20|    未激活   |   编辑/关闭  |
		|    naike     |  耐克男鞋   |2016-09-14 12:21|    未激活   |   编辑/关闭  |
		|   zhouheiya  |   周黑鸭    |2016-09-14 12:23|    未激活   |   编辑/关闭  |

