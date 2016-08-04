/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.permission:PermissionPage');
var React = require('react');
var ReactDOM = require('react-dom');
var classNames = require('classnames');

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
		Action.updatePermission(property, value);
	},

	onSubmit: function() {
		Action.savePermission(Store.getData());
	},

	componentDidMount: function() {
	},

	render:function(){
		return (
		<div className="xui-config-PermissionPage xui-formPage">
			<form className="form-horizontal mt15">
				<fieldset>
					<legend className="pl10 pt10 pb10">权限信息</legend>
					<Reactman.FormInput label="权限名:" name="name" validate="require-string" placeholder="比如：查看统计数据" value={this.state.name} onChange={this.onChange} autoFocus={true} />
					<Reactman.FormInput label="codename:" name="codename" validate="require-string" placeholder="比如：view_statistics" value={this.state.codename} onChange={this.onChange} />
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