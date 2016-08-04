/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.user:Action');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

var Constant = require('./Constant');

var Action = {
	updatePermission: function(property, value) {
		Dispatcher.dispatch({
			actionType: Constant.CONFIG_PERMISSION_UPDATE_PERMISSION,
			data: {
				property: property,
				value: value
			}
		});
	},

	savePermission: function(data) {
		var permission = {
			name: data['name'],
			codename: data['codename'],
		};
		Resource.put({
			resource: 'config.permission',
			data: permission,
			dispatch: {
				dispatcher: Dispatcher,
				actionType: Constant.CONFIG_PERMISSION_SAVE_PERMISSION
			}
		});		
	}
};

module.exports = Action;