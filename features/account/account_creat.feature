#author:徐梓豪 2016-09-13
#editor:李娜 2016.09.20
Feature:管理员管理开放平台
"""
1.管理员创建开放平台账号
2.管理员编辑开放平台账号
3.管理员关闭开放平台账号
"""
Background:
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
@poseidon	@kuki
Scenario:1 管理员创建开放平台账号
	Then manager查看账号列表
		| account_name |  main_name  |   create_time   |   state   |   operation  |
		|     aini     |   爱伲咖啡  |     今天        |   未激活  |   编辑/关闭  |

@poseidon
Scenario:2 管理员编辑开放平台账号
	When manager编辑账号'爱伲咖啡'
		"""
		[{
			"account_name":"aini",
			"password":"123456",
			"account_main":"爱伲coffee",
			"isopen":"是"
		}]
		"""
	Then manager查看账号列表
		| account_name |  main_name  |   creat_time   |   state   |   operation  |
		|     aini     |  爱伲coffee |      今天      |    未激活   |   编辑/关闭  |
	
@poseidon
Scenario:3 管理员关闭平台账号
	When manager关闭账号
		"""
		[{
			"account_name":"aini"
		}]
		"""
	Then manager查看账号列表
		| account_name |  main_name  |   creat_time   |   state   |   operation  |
		|     aini     |   爱伲咖啡  |      今天      |    未激活   |   编辑/开启  |

