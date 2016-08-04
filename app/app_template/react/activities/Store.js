/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

__STRIPPER_TAG__
var debug = require('debug')('m:app.{{resource.lower_name}}:activities:Store');
var EventEmitter = require('events').EventEmitter;
var assign = require('object-assign');
var _ = require('underscore');

__STRIPPER_TAG__
var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var StoreUtil = Reactman.StoreUtil;

__STRIPPER_TAG__
var Constant = require('./Constant');

__STRIPPER_TAG__
var Store = StoreUtil.createStore(Dispatcher, {
	actions: {
		'handleDeleteActivity': Constant.APP_{{uppercase_app_name}}_DELETE_ACTIVITY,
		'handleCloseActivity': Constant.APP_{{uppercase_app_name}}_CLOSE_ACTIVITY,
		'handleFilterActivities': Constant.APP_{{uppercase_app_name}}_FILTER_ACTIVITIES
	},

	__STRIPPER_TAG__
	init: function() {
		this.data = {
		};
	},

	__STRIPPER_TAG__
	handleDeleteActivity: function(action) {
		this.__emitChange();
	},

	__STRIPPER_TAG__
	handleCloseActivity: function(action) {
		this.__emitChange();
	},

	__STRIPPER_TAG__
	handleFilterActivities: function(action) {
		this.data.filterOptions = action.data;

		//将active_date_range改造为start_time与end_time的组合
		var activeDateRange = this.data.filterOptions['__f-active_date_range-range'];
		if (activeDateRange) {
			activeDateRange = JSON.parse(activeDateRange);
			if (activeDateRange[0]) {
				this.data.filterOptions['__f-start_time-gte'] = activeDateRange[0];
			}
			if (activeDateRange[1]) {
				this.data.filterOptions['__f-end_time-lte'] = activeDateRange[1];
			}
			delete this.data.filterOptions['__f-active_date_range-range'];
		}
		debug(this.data.filterOptions);
		this.__emitChange();
	},

	__STRIPPER_TAG__
	getData: function() {
		return this.data;
	}
});

__STRIPPER_TAG__
module.exports = Store;