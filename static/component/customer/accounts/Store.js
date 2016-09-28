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
		'handleGetCustomerStatus': Constant.CUSTOMER_ACCOUNTS_GET_CUSTOMER_STATUS
	},

	init: function() {
		this.data = {
			'customerId': -1,
			'logs': '[]'
		};
	},

	handleGetCustomerStatus: function(action) {
		this.data = action.data;
		this.__emitChange();
	},

	getData: function() {
		return this.data;
	}
});

module.exports = Store;