/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

__STRIPPER_TAG__
var debug = require('debug')('m:app.{{resource.lower_name}}:activities:Action');
var _ = require('underscore');

__STRIPPER_TAG__
var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

__STRIPPER_TAG__
var Constant = require('./Constant');

__STRIPPER_TAG__
var Action = {
	deleteActivity: function(id) {
		Resource.delete({
			resource: 'app.{{app_name}}.activity',
			data: {
				id: id
			},
			dispatch: {
				dispatcher: Dispatcher,
				actionType: Constant.APP_{{uppercase_app_name}}_DELETE_ACTIVITY
			}
		});
	},

	__STRIPPER_TAG__
	filterActivities: function(filterOptions) {
		Dispatcher.dispatch({
			actionType: Constant.APP_{{uppercase_app_name}}_FILTER_ACTIVITIES,
			data: filterOptions
		});
	},

	closeActivity: function(id) {
		Resource.post({
			resource: 'app.{{app_name}}.activity_status',
			data: {
				id: id,
				target: 'stoped'
			},
			dispatch: {
				dispatcher: Dispatcher,
				actionType: Constant.APP_{{uppercase_app_name}}_CLOSE_ACTIVITY
			}
		});
	}
};

module.exports = Action;