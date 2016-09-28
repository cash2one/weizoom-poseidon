#author:徐梓豪 2016-09-14
Feature:管理员通过登录名或主体名查询帐号 
"""
1.管理员通过登录名查询账号
2.管理员通过主体名查询账号
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
	Then manager查看账号列表
		| account_name |  main_name  |   create_time  |   status   |   operation  |
		|   zhouheiya  |   周黑鸭    |      今天      |   未激活   |   编辑/关闭  |
		|    naike     |  耐克男鞋   |      今天      |   未激活   |   编辑/关闭  |
		|     aini     |  爱伲咖啡   |      今天      |   未激活   |   编辑/关闭  |

@poseidon @search
Scenario:1 管理员通过登录名查询账号
	When manager通过登录名查询账号
		"""
		{
			"account_name":"aini"
		}
		"""
	Then manager获取账号列表
		| account_name |  main_name  |   create_time   |   status   |   operation  |
		|     aini     |  爱伲咖啡   |      今天       |   未激活   |   编辑/关闭  |
	When manager通过登录名查询账号
		"""
		{
			"account_name":"ai"
		}
		"""
	Then manager获取账号列表
		| account_name |  main_name  |   create_time  |   status   |   operation  |
		|    naike     |  耐克男鞋   |      今天      |   未激活   |   编辑/关闭  |
		|     aini     |  爱伲咖啡   |      今天      |   未激活   |   编辑/关闭  |
	When manager通过登录名查询账号
		"""
		{
		"account_name":"hs"
		}
		"""
	Then manager获取账号列表
		"""
		[]
		"""

@poseidon @search
Scenario:2 管理员通过主体名查询账号
	When manager通过主体名查询账号
		"""
		{
			"main_name":"爱伲咖啡"
		}
		"""
	Then manager获取账号列表
		| account_name |  main_name  |   create_time   |   status   |   operation  |
		|     aini     |  爱伲咖啡   |      今天       |   未激活   |   编辑/关闭  |
	When manager通过主体名查询账号
		"""
		{
			"main_name":"鸭"
		}
		"""
	Then manager获取账号列表
		| account_name |  main_name  |   create_time   |   status   |   operation  |
		|   zhouheiya  |   周黑鸭    |      今天       |   未激活   |   编辑/关闭  |
	When manager通过主体名查询账号
		"""
		{
			"main_name":"土小宝"
		}
		"""
	Then manager获取账号列表
		"""
		[]
		"""
		
