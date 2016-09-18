/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.user::Store');
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
		'handleUpdateUser': Constant.CONFIG_USER_UPDATE_USER,
		'handleSaveUser': Constant.CONFIG_USER_SAVE_USER
	},

	init: function() {
		this.data = {
			user: Reactman.loadJSON('user')
		};
		if (!this.data.user) {
			this.data.user = {
				id: -1,
				name: '',
				password: '',
				displayName: '',
				status: '1'
			};
		}
	},

	handleUpdateUser: function(action) {
		this.data.user[action.data.property] = action.data.value;
		this.__emitChange();
	},

	handleSaveUser: function() {
		W.gotoPage('/config/users/');
	},

	getData: function() {
		return this.data;
	}
});

module.exports = Store;