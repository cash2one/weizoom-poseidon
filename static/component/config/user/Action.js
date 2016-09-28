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
	updateUser: function(property, value) {
		Dispatcher.dispatch({
			actionType: Constant.CONFIG_USER_UPDATE_USER,
			data: {
				property: property,
				value: value
			}
		});
	},
	selectSelfShop: function(){
		Resource.get({
			resource: 'config.get_all_self_shops',
			data: {},
			dispatch: {
				dispatcher: Dispatcher,
				actionType: Constant.CONFIG_USER_SELECT_SELF_SHOP
			}
		})
	},
	saveUser: function(data) {
		var user = {
			name: data['name'],
			password: data['password'],
			display_name: data['displayName'],
			status: data['status'],
			woid: data['selfUserName']
		};
		if (data.id === -1) {
			Resource.put({
				resource: 'config.user',
				data: user,
				success: function() {
					Reactman.PageAction.showHint('success', '创建账号成功');
					setTimeout(function(){
						Dispatcher.dispatch({
							actionType: Constant.CONFIG_USER_SAVE_USER,
							data: data
						});
					},1000);
				},
				error: function(data) {
					Reactman.PageAction.showHint('error', data.errMsg);
				}
			});
		} else {
			user['id'] = data.id;
			Resource.post({
				resource: 'config.user',
				data: user,
				success: function() {
					Reactman.PageAction.showHint('success', '编辑账号成功');
					setTimeout(function(){
						Dispatcher.dispatch({
							actionType: Constant.CONFIG_USER_SAVE_USER,
							data: data
						});
					},1000);
				},
				error: function(data) {
					Reactman.PageAction.showHint('error', data.errMsg);
				}
			});
		}		
	}
};

module.exports = Action;