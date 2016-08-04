/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

__STRIPPER_TAG__
var debug = require('debug')('m:app.{{resource.lower_name}}:activity:Action');
var _ = require('underscore');

__STRIPPER_TAG__
var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

__STRIPPER_TAG__
var Constant = require('./Constant');

__STRIPPER_TAG__
var Action = {
	updateActivity: function(property, value) {
		Dispatcher.dispatch({
			actionType: Constant.APP_{{uppercase_app_name}}_UPDATE_ACTIVITY,
			data: {
				property: property,
				value: value
			}
		});
	},

	__STRIPPER_TAG__
	saveActivity: function(data) {
		var activity = {
			name: data['name'],
			start_time: data['activeDateRange'].low,
			end_time: data['activeDateRange'].high,
			detail: data['detail']
		};

		__STRIPPER_TAG__
		if (data.id === -1) {
			Resource.put({
				resource: 'app.{{app_name}}.activity',
				data: activity,
				dispatch: {
					dispatcher: Dispatcher,
					actionType: Constant.APP_{{uppercase_app_name}}_SAVE_ACTIVITY
				}
			});
		} else {
			activity['id'] = data.id;
			Resource.post({
				resource: 'app.{{app_name}}.activity',
				data: activity,
				dispatch: {
					dispatcher: Dispatcher,
					actionType: Constant.APP_{{uppercase_app_name}}_SAVE_ACTIVITY
				}
			});
		}		
	}
};

__STRIPPER_TAG__
module.exports = Action;