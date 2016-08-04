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
		'handleUpdatePermission': Constant.CONFIG_USER_UPDATE_PERMISSION,
		'handleUpdateUser': Constant.CONFIG_USER_UPDATE_USER,
		'handleSaveUser': Constant.CONFIG_USER_SAVE_USER
	},

	init: function() {
		this.data = {
			user: Reactman.loadJSON('user'),
			groups: _.sortBy(Reactman.loadJSON('groups'), 'id'),
			permissions: _.sortBy(Reactman.loadJSON('permissions'), 'id')
		};
		if (!this.data.user) {
			this.data.user = {
				id: -1,
				name: '',
				password: '',
				displayName: '',
				group: '2', //2 is for 运营,
				permissions: []
			};
		}
	},

	handleUpdatePermission: function(action) {
		this.__emitChange();
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