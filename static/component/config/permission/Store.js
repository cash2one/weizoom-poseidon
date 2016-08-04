/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.permission::Store');
var EventEmitter = require('events').EventEmitter;
var assign = require('object-assign');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var StoreUtil = Reactman.StoreUtil;
var W = Reactman.W;

var Constant = require('./Constant');

var Store = StoreUtil.createStore(Dispatcher, {
	actions: {
		'handleUpdatePermission': Constant.CONFIG_PERMISSION_UPDATE_PERMISSION,
		'handleSavePermission': Constant.CONFIG_PERMISSION_SAVE_PERMISSION
	},

	init: function() {
		this.data = {
			id: -1,
			name: ''
		};
	},

	handleUpdatePermission: function(action) {
		this.data[action.data.property] = action.data.value;
		this.__emitChange();
	},

	handleSavePermission: function() {
		W.gotoPage('/config/permissions/');
	},

	getData: function() {
		return this.data;
	}
});

module.exports = Store;