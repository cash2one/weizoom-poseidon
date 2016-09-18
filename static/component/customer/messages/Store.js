/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:outline.datas:Store');
var EventEmitter = require('events').EventEmitter;
var assign = require('object-assign');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var StoreUtil = Reactman.StoreUtil;

var Constant = require('./Constant');

var Store = StoreUtil.createStore(Dispatcher, {
	actions: {
		'handleUpdateMessage': Constant.CUSTOMER_MESSAGES_UPDATEM_MESSAGE,
		'handleAddServerIp': Constant.CUSTOMER_MESSAGES_ADD_SERVER_IP,
		'handlesSveMessages': Constant.CUSTOMER_MESSAGES_SAVE_MESSAGES
	},

	init: function() {
		this.data = {
			'id':-1,
			'serverIps': []
		};
	},

	handleUpdateMessage: function(action) {
		this.data[action.data.property] = action.data.value;
		this.__emitChange();
	},

	handleAddServerIp: function(action) {
		var serverIps = this.data.serverIps;
		serverIps.push({
			'ipName': ''
		});
		this.data.serverIps = serverIps;
		this.__emitChange();
	},

	handlesSveMessages: function(){
		setTimeout(function() {
		 	Reactman.PageAction.showHint('success', '提交成功!');
		}, 10);
		setTimeout(function() {
		 	W.gotoPage('/customer/accounts/');
		}, 500);
	},

	getData: function() {
		return this.data;
	}
});

module.exports = Store;