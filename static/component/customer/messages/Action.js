/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:outline.datas:Action');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

var Constant = require('./Constant');

var Action = {
	updateMessage: function(property, value) {
		Dispatcher.dispatch({
			actionType: Constant.CUSTOMER_MESSAGES_UPDATEM_MESSAGE,
			data: {
				property: property,
				value: value
			}
		});
	},

	addServerIp: function(){
		Dispatcher.dispatch({
			actionType: Constant.CUSTOMER_MESSAGES_ADD_SERVER_IP,
			data: {}
		});
	},

	saveMessages: function(data){
		var messages = {
			'name': data.name,
			'mobileNumber': data.mobileNumber,
			'email': data.email,
			'interfaceUrl': data.interfaceUrl,
			'serverIp': data.serverIp,
			'serverIps': JSON.stringify(data.serverIps)
		}
		
		if (data.id === -1) {
			Resource.put({
				resource: 'customer.messages',
				data: messages,
				success: function() {
					Dispatcher.dispatch({
						actionType: Constant.CUSTOMER_MESSAGES_SAVE_MESSAGES,
						data: data
					})
				},
				error: function(data) {
					Reactman.PageAction.showHint('error', '提交失败');
				}
			});
		} else {
			product['id'] = data.id;
			Resource.post({
				resource: 'customer.messages',
				data: product,
				dispatch: {
					dispatcher: Dispatcher,
					actionType: Constant.OUTLINE_DATA_SAVE_PRODUCT
				}
			});
		}
	}
};

module.exports = Action;