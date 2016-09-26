#author:徐梓豪 2016-09-14
Feature:普通账号登录系统
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


@poserdon
Scenario:1 普通账号登录系统
	Given aini使用密码123456登录系统
	Then aini成功进入系统

