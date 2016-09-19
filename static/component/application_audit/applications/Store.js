/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:application_audit.applications:Store');
var EventEmitter = require('events').EventEmitter;
var assign = require('object-assign');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var StoreUtil = Reactman.StoreUtil;

var Constant = require('./Constant');

var Store = StoreUtil.createStore(Dispatcher, {
	actions: {
		'handleUpdateApplication': Constant.UPDATE_APPLICATION,
		'handleFilterApplication': Constant.FILTER_APPLICATION
	},

	init: function() {
		this.data = {
		};
	},
	
	handleFilterApplication: function(action) {
		this.data.filterOptions = action.data;
		this.__emitChange();
	},

	handleUpdateApplication: function(action) {
		this.data = action.data;
		this.__emitChange();
	},

	getData: function() {
		return this.data;
	}
});

module.exports = Store;