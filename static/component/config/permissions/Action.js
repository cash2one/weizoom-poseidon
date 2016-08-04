/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.permissions:Action');
var _ = require('underscore');

var Reactman = require('reactman');
var Dispatcher = Reactman.Dispatcher;
var Resource = Reactman.Resource;

var Action = {
	deletePermission: function(id, callback) {
		Resource.delete({
			resource: 'config.permission',
			data: {
				id: id
			},
			success: function(data) {
				callback();
			}
		});
	}
};

module.exports = Action;