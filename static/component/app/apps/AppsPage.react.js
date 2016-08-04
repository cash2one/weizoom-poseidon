/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:app.apps:AppsPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var AppsPage = React.createClass({
	getInitialState: function() {
		return null;
	},

	render:function(){
		return (
		<div className="mt15 xui-app-appsPage">
			您当前没有运营活动，请添加
		</div>
		)
	}
})
module.exports = AppsPage;