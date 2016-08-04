/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:app.activity:activities:CopyLinkPopover');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

require('./style.css');

var CopyLinkPopover = React.createClass({
	componentDidMount: function() {
		var $popover = $(ReactDOM.findDOMNode(this));
		var $el = $popover.find('.xa-zeroclipboard-copyTrigger');
		debug($el.length);
		if ($el.length > 0) {
			var clip = new ZeroClipboard($el.get(0), {
          		moviePath: "/static/zero_clipboard.swf"
        	});

        	clip.on('complete', function(client, args) {
        		Reactman.PageAction.hidePopover();
        		Reactman.PageAction.showHint('success', '复制成功');
	        });
		}
	},
	
	render:function(){
		var style = {
			width: '180px'
		}

		return (
		<div className="xa-copyLink">
			<input type="text" className="xa-link" value={this.props.url} readOnly style={style} id="-zeroclipboard-valueInput"></input>
			<a className="btn btn-primary btn-sm ml10 xa-zeroclipboard-copyTrigger" data-clipboard-target="-zeroclipboard-valueInput">复制</a>
		</div>
		)
	}
})
module.exports = CopyLinkPopover;
