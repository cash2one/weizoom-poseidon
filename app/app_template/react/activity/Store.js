/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

__STRIPPER_TAG__
var debug = require('debug')('m:app.{{resource.lower_name}}:activity:Store');
var EventEmitter = require('events').EventEmitter;
var assign = require('object-assign');
var _ = require('underscore');

__STRIPPER_TAG__
var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var StoreUtil = Reactman.StoreUtil;

__STRIPPER_TAG__
var Constant = require('./Constant');

var Store = StoreUtil.createStore(Dispatcher, {
	actions: {
		'handleUpdateActivity': Constant.APP_{{uppercase_app_name}}_UPDATE_ACTIVITY,
		'handleSaveActivity': Constant.APP_{{uppercase_app_name}}_SAVE_ACTIVITY
	},

	__STRIPPER_TAG__
	init: function() {
		this.data = Reactman.loadJSON('activity');
		if (this.data) {
			this.data['activeDateRange'] = {
				low: this.data.startTime,
				high: this.data.endTime
			}
		} else {
			this.data = {
				'id':-1, 
				'name': '',
				'detail': '',
				'activeDateRange': {
					low: '',
					high: ''
				}
			};
		}
	},

	__STRIPPER_TAG__
	handleUpdateActivity: function(action) {
		debug('update %s to %s', action.data.property, JSON.stringify(action.data.value));
		this.data[action.data.property] = action.data.value;
		this.__emitChange();
	},

	__STRIPPER_TAG__
	handleSaveActivity: function() {
		Reactman.W.gotoPage('/app/{{app_name}}/activities/');
	},

	__STRIPPER_TAG__
	getData: function() {
		return this.data;
	}
});

__STRIPPER_TAG__
module.exports = Store;