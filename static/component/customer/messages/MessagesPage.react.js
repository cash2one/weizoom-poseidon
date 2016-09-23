/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:customer.messages:MessagesPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');
var ServerIpList = require('./ServerIpList.react');

require('./style.css');

var MessagesPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	onChangeStore: function() {
		this.setState(Store.getData());
	},

	onChange: function(value, event) {
		var property = event.target.getAttribute('name');
		Action.updateMessage(property, value);
	},

	onSubmit: function() {
		var data = Store.getData();
		var mobileReg = /^1[3|4|5|7|8][0-9]{9}$/; //验证手机
		var emailReg = /^([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)$/g; //验证邮箱
		var ipReg = /^((2[0-4]\d|25[0-5]|[1-9]?\d|1\d{2})\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$/ //验证ip
		var strRegex = "^((https|http|ftp|rtsp|mms)?://)"         
                    + "?(([0-9a-zA-Z_!~*'().&=+$%-]+: )?[0-9a-zA-Z_!~*'().&=+$%-]+@)?" //ftp的user@        
                    + "(([0-9]{1,3}\.){3}[0-9]{1,3}" // IP形式的URL- 199.194.52.184        
                    + "|" // 允许IP和DOMAIN（域名）        
                    + "([0-9a-zA-Z_!~*'()-]+\.)*" // 域名- www.        
                    + "([0-9a-zA-Z][0-9a-zA-Z-]{0,61})?[0-9a-zA-Z]\." // 二级域名        
                    + "[a-zA-Z]{2,6})" // first level domain- .com or .museum        
                    + "(:[0-9]{1,4})?" // 端口- :80        
                    + "((/?)|"         
                    + "(/[0-9a-zA-Z_!~*'().;?:@&=+$,%#-]+)+/?)$";  

   		var urlReg = new RegExp(strRegex);

		if(!mobileReg.test(data.mobileNumber)){
			Reactman.PageAction.showHint('error', '请输入有效的手机号!');
			return;
		}
		if(!emailReg.test(data.email)){
			Reactman.PageAction.showHint('error', '请输入有效的邮箱!');
			return;
		}
		if(!ipReg.test(data.serverIp)){
			Reactman.PageAction.showHint('error', '请输入有效的IP!');
			return;
		}
		if(!urlReg.test(data.interfaceUrl)){
			Reactman.PageAction.showHint('error', '请输入有效的URL!');
			return;
		}

		var serverIps = data.serverIps;
		var isPass = true;

		_.each(serverIps, function(serverIp){
			if(!ipReg.test(serverIp.ipName)){
				isPass = false;
			}
		})

		if(!isPass){
			Reactman.PageAction.showHint('error', '请输入有效的IP!');
			return;
		}
		var messages = {
			'id': data.id,
			'name': data.name,
			'mobileNumber': data.mobileNumber,
			'email': data.email,
			'interfaceUrl': data.interfaceUrl,
			'serverIp': data.serverIp,
			'serverIps': JSON.stringify(data.serverIps)
		}
		Action.saveMessages(messages);
	},

	componentDidMount: function() {
		debug(ReactDOM.findDOMNode(this.refs.name));
	},

	render:function(){
		return (
		<div className="xui-messagesData-page xui-formPage">
			<form className="form-horizontal mt15">
				<fieldset style={{paddingTop: '20px'}}>
					<Reactman.FormInput label="开发者姓名:" name="name" validate="require-string" value={this.state.name} onChange={this.onChange} />
					<Reactman.FormInput label="手机号:" name="mobileNumber" validate="require-string" value={this.state.mobileNumber} onChange={this.onChange} />
					<Reactman.FormInput label="邮箱:" name="email" validate="require-string" value={this.state.email} onChange={this.onChange} />
					<ServerIpList name='serverIps' serverIps={this.state.serverIps} serverIp={this.state.serverIp} onChange={this.onChange} />
					<Reactman.FormInput label="接口回调地址:" name="interfaceUrl" validate="require-string" value={this.state.interfaceUrl} onChange={this.onChange} />
				</fieldset>

				<fieldset>
					<Reactman.FormSubmit onClick={this.onSubmit} text="提交审核"/>
				</fieldset>
			</form>
		</div>
		)
	}
})

module.exports = MessagesPage;