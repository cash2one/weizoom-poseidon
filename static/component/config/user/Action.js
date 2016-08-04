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
	updatePermission: function(index, name, stocks) {
		Dispatcher.dispatch({
			actionType: Constant.CONFIG_USER_UPDATE_PERMISSION,
			data: {
				index: index,
				name: name,
				stocks: stocks
			}
		});
	},

	updateUser: function(property, value) {
		Dispatcher.dispatch({
			actionType: Constant.CONFIG_USER_UPDATE_USER,
			data: {
				property: property,
				value: value
			}
		});
	},

	saveUser: function(data) {
		var user = {
			name: data['name'],
			password: data['password'],
			display_name: data['displayName'],
			email: data['email'],
			group: data['group'],
			permissions: JSON.stringify(data['permissions'])
		};
		if (data.id === -1) {
			Resource.put({
				resource: 'config.user',
				data: user,
				dispatch: {
					dispatcher: Dispatcher,
					actionType: Constant.CONFIG_USER_SAVE_USER
				}
			});
		} else {
			user['id'] = data.id;
			Resource.post({
				resource: 'config.user',
				data: user,
				dispatch: {
					dispatcher: Dispatcher,
					actionType: Constant.CONFIG_USER_SAVE_USER
				}
			});
		}		
	}
};

module.exports = Action;