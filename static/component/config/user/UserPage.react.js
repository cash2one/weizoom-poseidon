/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.user:UserPage');
var React = require('react');
var ReactDOM = require('react-dom');
var classNames = require('classnames');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

var Store = require('./Store');
var Action = require('./Action');

var UserPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	onChangeStore: function() {
		this.setState(Store.getData());
	},

	onChange: function(value, event) {
		var property = event.target.getAttribute('name');
		Action.updateUser(property, value);
	},

	onSubmit: function() {
		var account = Store.getData().user;
		var regUsername = /^[0-9a-zA-Z]*$/g;
		var regPsw = /^[0-9a-zA-Z]{6,20}$/g;
		if(!regUsername.test(account.name.trim())){
			Reactman.PageAction.showHint('error', '登录名请填写英文字母或数字');
			return;
		}
		if(!regPsw.test(account.password.trim())){
			Reactman.PageAction.showHint('error', '请输入6-20位数字英文任意组合');
			return;
		}
		Action.saveUser(Store.getData().user);
	},

	componentDidMount: function() {
	},

	render:function(){
		var optionsForStatus = [{
			text: '是',
			value: '1'
		}, {
			text: '否',
			value: '0'
		}];
		
		if (this.state.user.id === -1) {
            var labelName = '登录密码:';
			var validate = "require-notempty";
        } else {
            var labelName = '修改密码:';
			var validate = "";
        }

		return (
		<div className="xui-outlineData-page xui-formPage">
			<form className="form-horizontal mt15">
				<fieldset>
					<legend className="pl10 pt10 pb10">用户信息</legend>
					<Reactman.FormInput label="登录名:" name="name" validate="require-notempty" placeholder="英文或数字任意组合" value={this.state.user.name} onChange={this.onChange} autoFocus={true} />
					<Reactman.FormInput label={labelName} name="password" validate={validate} placeholder="6-20位数字英文任意组合" value={this.state.user.password} onChange={this.onChange} />
					<Reactman.FormInput label="账号主体:" name="displayName" validate="require-string" placeholder="开放平台个人或公司名称" value={this.state.user.displayName} onChange={this.onChange} />
					<Reactman.FormRadio label="是否开启:" name="status" value={this.state.user.status} options={optionsForStatus} onChange={this.onChange} />
				</fieldset>
				<fieldset>
					<Reactman.FormSubmit onClick={this.onSubmit} text="确 定"/>
				</fieldset>
			</form>
		</div>
		)
	}
})
module.exports = UserPage;