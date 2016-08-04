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

//var ProductModelList = require('./ProductModelList.react');
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
		Action.saveUser(Store.getData().user);
	},

	componentDidMount: function() {
	},

	render:function(){
		var optionsForGroup = _.map(this.state.groups, function(group) {
			return {
				text: group.displayName,
				value: ""+group.id
			}
		});

		var optionsForPermission = _.map(this.state.permissions, function(permission) {
			return {
				text: permission.name,
				value: ""+permission.id,
				selectable: permission.selectable
			}
		});

		var mPassword = null;
		if (this.state.user.id === -1) {
			mPassword = (
				<Reactman.FormInput label="密码:" name="password" validate="require-string" placeholder="" value={this.state.user.password} onChange={this.onChange} />
			);
		} else {
			mPassword = '';
		}

		return (
		<div className="xui-outlineData-page xui-formPage">
			<form className="form-horizontal mt15">
				<fieldset>
					<legend className="pl10 pt10 pb10">用户信息</legend>
					<Reactman.FormInput label="登录名:" name="name" validate="require-string" placeholder="" value={this.state.user.name} onChange={this.onChange} autoFocus={true} />
					{mPassword}
					<Reactman.FormInput label="真实名:" name="displayName" validate="require-string" placeholder="" value={this.state.user.displayName} onChange={this.onChange} />
					<Reactman.FormInput label="电子邮箱:" name="email" validate="require-string" placeholder="" value={this.state.user.email} onChange={this.onChange} />
					<Reactman.FormRadio label="部门:" name="group" value={this.state.user.group} options={optionsForGroup} onChange={this.onChange} />
				</fieldset>

				<fieldset className="form-inline">
					<legend className="pl10 pt10 pb10">权限</legend>
					<Reactman.FormCheckbox label="" name="permissions" value={this.state.user.permissions} options={optionsForPermission} onChange={this.onChange} />
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