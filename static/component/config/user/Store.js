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
		'handleSaveUser': Constant.CONFIG_USER_SAVE_USER,
		'handleSelect': Constant.CONFIG_USER_SELECT_SELF_SHOP
	},

	init: function() {
		this.data = {
			user: Reactman.loadJSON('user')
		};
		this.data.user['options'] = [];
		if (!this.data.user) {
			this.data.user = {
				id: -1,
				name: '',
				password: '',
				displayName: '',
				status: '1',
				options: []
			};
		}
	},

	handleUpdateUser: function(action) {
		this.data.user[action.data.property] = action.data.value;
		this.__emitChange();
	},

	handleSelect: function(action) {
		this.data.user['options'] = action.data.rows;
		if(this.data.user['options'].length > 0){
			this.data.user['selfUserName'] = this.data.user['options'][0]['value']
		}
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