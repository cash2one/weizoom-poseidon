/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

__STRIPPER_TAG__
var debug = require('debug')('m:app.{{resource.lower_name}}:activity:ActivityPage');
var React = require('react');
var ReactDOM = require('react-dom');

__STRIPPER_TAG__
var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

__STRIPPER_TAG__
var Store = require('./Store');
var Action = require('./Action');

__STRIPPER_TAG__
var ActivityPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	__STRIPPER_TAG__
	onChangeStore: function() {
		this.setState(Store.getData());
	},

	__STRIPPER_TAG__
	onChange: function(value, event) {
		var property = event.target.getAttribute('name');
		Action.updateActivity(property, value);
	},

	__STRIPPER_TAG__
	onSubmit: function() {
		Action.saveActivity(Store.getData());
	},

	__STRIPPER_TAG__
	render:function(){
		return (
		<div className="xui-app-{{app_name}}-activityPage xui-formPage">
			<form className="form-horizontal mt15">
				<fieldset className="form-inline">
					<legend className="pl10 pt10 pb10">活动信息</legend>
					<Reactman.FormInput label="活动名:" name="name" validate="require-string" placeholder="" value={this.state.name} onChange={this.onChange} autoFocus={true} />
					<Reactman.FormDateRangeInput label="起止时间:" name="activeDateRange" min="now" placeholder="促销结束日期" value={this.state.activeDateRange} onChange={this.onChange} validate="require-string" />
				</fieldset>

				<fieldset>
					<Reactman.FormSubmit onClick={this.onSubmit} text="确 定"/>
				</fieldset>
			</form>
		</div>
		)
	}
})
module.exports = ActivityPage;