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
		Action.saveMessages(Store.getData());
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