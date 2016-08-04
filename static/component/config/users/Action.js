/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.users:Action');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

var Constant = require('./Constant');

var Action = {
	deleteUser: function(id, callback) {
		Resource.delete({
			resource: 'config.user',
			data: {
				id: id
			},
			success: function(data) {
				callback();
			}
		});
	},

	filterUser: function(filterOptions) {
		Dispatcher.dispatch({
			actionType: Constant.CONFIG_USERS_FILTER_USER,
			data: filterOptions
		});
	}
};

module.exports = Action;