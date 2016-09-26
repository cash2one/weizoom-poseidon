/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:application_audit.applications:ApplicationDialog');
var React = require('react');
var ReactDOM = require('react-dom');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

var ApplicationDialog = Reactman.createDialog({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		var id = this.props.data.id;
		return {
			id: id
		}
	},

	onChange: function(value, event) {
		var property = event.target.getAttribute('name');
		var newState = {};
		newState[property] = value;
		this.setState(newState);
	},

	onChangeStore: function(){
		var infomations = Store.getData();
		this.setState({
			reason: infomations['reason']
		})
	},

	onBeforeCloseDialog: function() {
		Reactman.Resource.put({
			resource: 'application_audit.applications',
			data: {
				id: this.state.id,
				reason: this.state.reason
			},
			success: function() {
				this.closeDialog();
				_.delay(function(){
					Reactman.PageAction.showHint('success', '驳回成功');
				},500);
			},
			error: function(data) {
				Reactman.PageAction.showHint('error', data.errMsg);
			},
			scope: this
		})
	},

	render:function(){
		return (
		<div className="xui-formPage">
			<form className="form-horizontal mt15">
				<fieldset>
					<Reactman.FormText label="驳回原因:" type="text" name="reason" validate="require-notempty" value={this.state.reason} onChange={this.onChange} autoFocus={true} inDialog={true} width={300} height={200} />
				</fieldset>
			</form>
		</div>
		)
	}
})
module.exports = ApplicationDialog;