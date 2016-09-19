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
	getCustomerStatus: function() {
		Resource.get({
			resource: 'customer.accounts',
			data: {},
			dispatch: {
				dispatcher: Dispatcher,
				actionType: Constant.CUSTOMER_ACCOUNTS_GET_CUSTOMER_STATUS
			}
		});
	},

	updateProduct: function(product, field, data) {
		Dispatcher.dispatch({
			actionType: Constant.OUTLINE_DATAS_UPDATE_PRODUCT,
			data: {
				product: product,
				field: field,
				data: data
			}
		});
	}
};

module.exports = Action;