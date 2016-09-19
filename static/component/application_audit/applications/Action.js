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
	ChangeStatus: function(id, _method, callback) {
		Resource.post({
			resource: 'application_audit.applications',
			data: {
				id: id,
				method: _method
			},
			success: function() {
				Reactman.PageAction.showHint('success', '修改状态成功');
				callback();
			},
			error: function(data) {
				Reactman.PageAction.showHint('error', data.errMsg);
			}
		});
	},

	updateApplication: function() {
		Dispatcher.dispatch({
			actionType: Constant.UPDATE_APPLICATION,
			data: {}
		});
	}
};

module.exports = Action;