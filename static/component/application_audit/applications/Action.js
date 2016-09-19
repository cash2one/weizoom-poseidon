/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:application_audit.applications:Action');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

var Constant = require('./Constant');

var Action = {
	passAudit: function(id, callback) {
		Resource.post({
			resource: 'application_audit.applications',
			data: {
				id: id
			},
			success: function() {
				Reactman.PageAction.showHint('success', '审核成功');
				callback();
			},
			error: function(data) {
				Reactman.PageAction.showHint('error', data.errMsg);
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