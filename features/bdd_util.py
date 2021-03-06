# -*- coding: utf-8 -*-
import json
import time
import logging
from datetime import datetime, timedelta
from django.test.client import Client
from django.http import SimpleCookie
from django.contrib.auth.models import User
from django.db.models import Model
from account.models import UserProfile
from poseidon import settings

tc = None

BOUNDARY = 'BoUnDaRyStRiNg'
MULTIPART_CONTENT = 'multipart/form-data; boundary=%s' % BOUNDARY

class WeappClient(Client):
	def __init__(self, enforce_csrf_checks=False, **defaults):
		super(WeappClient, self).__init__(**defaults)

	def request(self, **request):
		if settings.DUMP_TEST_REQUEST:
			print '\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
			print '{{{ request'
	
		response = super(WeappClient, self).request(**request)
	
		if settings.DUMP_TEST_REQUEST:
			print '}}}'
			print '\n{{{ response'
			print self.cookies
			print '}}}'
			print '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n'
		return response


	def reset(self):
		self.cookies = SimpleCookie()
		if hasattr(self, 'user'):
			self.user = User()

def __new_client_put(self, url, data):
	if url[-1] == '/':
		url = url + '?_method=put'
	else:
		url = url + '/?_method=put'
	return self.post(url, data)

def __new_client_delete(self, url, data):
	if url[-1] == '/':
		url = url + '?_method=delete'
	else:
		url = url + '/?_method=delete'
	return self.post(url, data)

Client.put = __new_client_put
Client.delete = __new_client_delete

###########################################################################
# login: 登录系统
###########################################################################
def login(user, password=None, **kwargs):
	if not password:
		password = 'test'
	if 'context' in kwargs:
		context = kwargs['context']
		if hasattr(context, 'client'):
			if context.client.user.username == user:
				#如果已经登录了，且登录用户与user相同，直接返回
				return context.client
			else:
				#如果已经登录了，且登录用户不与user相同，退出登录
				context.client.logout()

	#client = WeappClient(HTTP_USER_AGENT='WebKit MicroMessenger Mozilla')
	client = Client()
	client.login(username=user, password=password)
	client.user = User.objects.get(username=user)
	client.user.profile = UserProfile.objects.get(user=client.user)

	if 'context' in kwargs:
		context = kwargs['context']
		context.client = client

	return client


###########################################################################
# get_user_id_for: 获取username对应的user的id
###########################################################################
def get_user_id_for(username):
	return User.objects.get(username=username).id



def convert_to_same_type(a, b):
	def to_same_type(target, other):
		target_type = type(target)
		other_type = type(other)
		if other_type == target_type:
			return True, target, other

		if (target_type == int) or (target_type == float):
			try:
				other = target_type(other)
				return True, target, other
			except:
				return False, target, other

		return False, target, other

	is_success, new_a, new_b = to_same_type(a, b)
	if is_success:
		return new_a, new_b
	else:
		is_success, new_b, new_a = to_same_type(b, a)
		if is_success:
			return new_a, new_b

	return a, b


###########################################################################
# assert_dict: 验证expected中的数据都出现在了actual中
###########################################################################
def assert_dict(expected, actual):
	global tc
	is_dict_actual = isinstance(actual, dict)
	for key in expected:
		expected_value = expected[key]
		if is_dict_actual:
			actual_value = actual[key]
		else:
			actual_value = getattr(actual, key)

		if isinstance(expected_value, dict):
			assert_dict(expected_value, actual_value)
		elif isinstance(expected_value, list):
			assert_list(expected_value, actual_value)
		else:
			try:
				tc.assertEquals(expected_value, actual_value)
			except Exception, e:
				items = ['\n<<<<<', 'e: %s' % str(expected), 'a: %s' % str(actual), 'key: %s' % key, e.args[0], '>>>>>\n']
				e.args = ('\n'.join(items),)
				raise e

tc = None

def assert_list(expected, actual, options=None):
	"""
	验证expected中的数据都出现在了actual中
	"""
	global tc
	try:
		tc.assertEquals(len(expected), len(actual), 'list length DO NOT EQUAL: %d != %d' % (len(expected), len(actual)))
	except:
		if options and 'key' in options:
			print '      Outer Compare Dict Key: ', options['key']
		raise

	for i in range(len(expected)):
		expected_obj = expected[i]
		actual_obj = actual[i]
		if isinstance(expected_obj, dict):
			assert_dict(expected_obj, actual_obj)
		else:
			expected_obj, actual_obj = convert_to_same_type(expected_obj, actual_obj)
			tc.assertEquals(expected_obj, actual_obj)


###########################################################################
# assert_expected_list_in_actual: 验证expected中的数据都出现在了actual中
###########################################################################
def assert_expected_list_in_actual(expected, actual):
	global tc

	for i in range(len(expected)):
		expected_obj = expected[i]
		actual_obj = actual[i]
		if isinstance(expected_obj, dict):
			assert_dict(expected_obj, actual_obj)
		else:
			try:
				tc.assertEquals(expected_obj, actual_obj)
			except Exception, e:
				items = ['\n<<<<<', 'e: %s' % str(expected), 'a: %s' % str(actual), 'key: %s' % key, e.args[0], '>>>>>\n']
				e.args = ('\n'.join(items),)
				raise e


###########################################################################
# assert_api_call_success: 验证api调用成功
###########################################################################
def assert_api_call_success(response):
	if '<!DOCTYPE html>' in response.content:
		logging.error(response.content)
		assert False, "NOT a valid json string, call api FAILED!!!!"
	else:
		content = json.loads(response.content)
		assert 200 == content['code'], "code != 200, call api FAILED!!!!"
		return content


###########################################################################
# print_json: 将对象以json格式输出
###########################################################################
def print_json(obj):
	print json.dumps(obj, indent=True)


def get_date(str):
	"""
		将字符串转成datetime对象
		今天 -> 2014-4-18
	"""
	#处理expected中的参数
	today = datetime.now()
	if str == u'今天':
		delta = 0
	elif str == u'昨天':
		delta = -1
	elif str == u'前天':
		delta = -2
	elif str == u'明天':
		delta = 1
	elif str == u'后天':
		delta = 2
	elif u'天后' in str:
		delta = int(str[:-2])
	elif u'天前' in str:
		delta = 0-int(str[:-2])
	else:
		tmp = str.split(' ')
		if len(tmp) == 1:
			strp = "%Y-%m-%d"
		elif len(tmp[1]) == 8:
			strp = "%Y-%m-%d %H:%M:%S"
		elif len(tmp[1]) == 5:
			strp = "%Y-%m-%d %H:%M"
		return datetime.strptime(str, strp)

	return today + timedelta(delta)

def get_date_to_time_interval (str):
	"""
		将如下格式转化为字符串形式的时间间隔
		今天 -> 2014-2-13|2014-2-14
		"3天前-1天前" 也转为相同的格式
	"""
	date_interval = None
	if u'-' in str:
		m = re.match(ur"(\d*)([\u4e00-\u9fa5]{1,2})[-](\d*)([\u4e00-\u9fa5]{1,2})", unicode(str))
		result = m.group(1, 2, 3, 4)
		if result:
			if result[1] == u'天前' and result[3] == u'天前':
				date_interval = "%s|%s" % (datetime.strftime(datetime.now()-timedelta(days=int(result[0])), "%Y-%m-%d"), datetime.strftime(datetime.now() - timedelta(days=int(result[2])),"%Y-%m-%d"))
			if result[1] == u'天前' and result[2] == u'' and result[3] == u'今天':
				date_interval = "%s|%s" % (datetime.strftime(datetime.now() - timedelta(days=int(result[0])),"%Y-%m-%d"), datetime.strftime(datetime.now(),"%Y-%m-%d"))
			if result[1] == u'今天' and result[3] == u'明天':
				date_interval = "%s|%s" % (datetime.strftime(datetime.now(), "%Y-%m-%d"), datetime.strftime(datetime.now() + timedelta(days=1),"%Y-%m-%d"))
	return date_interval

#def parse_datetime(str):
#	return datetime.strptime(str, "%Y/%m/%d %H:%M:%S")

def get_date_str(str):
	date = get_date(str)
	return date.strftime('%Y-%m-%d')

def get_datetime_str(str):
	"""保留小时数
	"""
	date = get_date(str)
	return '%s 00:00:00' % date.strftime('%Y-%m-%d')

def get_datetime_no_second_str(str):
	date = get_date(str)
	return '%s 00:00' % date.strftime('%Y-%m-%d')

def table2dict(context):
	expected = []
	for row in context.table:
		data = {}
		for heading in row.headings:
			if ':' in heading:
				real_heading, value_type = heading.split(':')
			else:
				real_heading = heading
				value_type = None
			value = row[heading]
			if value_type == 'i':
				value = int(value)
			if value_type == 'f':
				value = float(value)
			data[real_heading] = value
		expected.append(data)
	return expected

def __date2time(date_str):
	"""
	字符串 今天/明天……
	转化为字符串 "%Y-%m-%d %H:%M"
	"""
	cr_date = date_str
	p_time = "{} 00:00".format(get_date_str(cr_date))
	return p_time

def __datetime2str(dt_time):
	"""
	时间转换为字符串【今天】
	"""
	date_now = datetime.now().strftime('%Y-%m-%d %H:%M')
	if date_now == dt_time:
		return u'今天'
	else:
		return u'其他'