/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:customer.messages:ServerIpList');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

require('./style.css');

var ServerIpList = React.createClass({
	getInitialState: function() {
		return {
			'serverIps': this.props.serverIps
		}
	},

	onClickAddIp: function(){
		Action.addServerIp();
	},

	onClickDelete: function(index){
		this.state.serverIps.splice(index, 1);
		this.props.onChange(this.state.serverIps, event);
	},

	onChangeServerIp: function(index, value, event) {
		var server = this.state.serverIps[index];
		server.ipName = value;
		this.props.onChange(this.state.serverIps, event);
	},

	render:function(){
		var serverIps = this.state.serverIps;
		var cModels = '';
		if (serverIps) {
			var _this = this;
			cModels = serverIps.map(function(serverIp, index) {
				return (
					<div className="xi-serverIp" key={index}>
						<Reactman.FormInput label="" type="text" name="ipName" validate="require-string" placeholder="" value={serverIp.ipName} onChange={_this.onChangeServerIp.bind(_this, index)} />
						<a className="btn btn-default ml20" style={{'verticalAlign':'top'}} onClick={_this.onClickDelete.bind(_this, index)}><span className="glyphicon glyphicon-remove"></span></a>
					</div>
				)
			});
		}

		return (
			<div style={{position: 'relative'}}>
				<Reactman.FormInput label="服务器IP:" name="serverIp" value={this.props.serverIp} onChange={this.props.onChange} validate="require-string"/>
				{cModels}
				<a className="add-server-btn" href="javascript:void(0);" onClick={this.onClickAddIp}>+ 增加</a>
			</div>
		)
	}
})

module.exports = ServerIpList;