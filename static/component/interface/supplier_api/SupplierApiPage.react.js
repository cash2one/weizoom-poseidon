/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:interface.product_api:ProductApiPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

require('./style.css');

var ProductApiPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	onChangeStore: function(event) {
		var filterOptions = Store.getData().filterOptions;
		this.refs.table.refresh(filterOptions);
	},

	render:function(){
		return (
			<div className="mt15 xui-interface-productApiPage">
				<table className="table table-bordered" style={{width:'80%'}}>
					<tbody>
						<tr>
							<td colSpan="2" style={{background:'#FF6600', color:'#FFF'}}>API列表</td>
						</tr>
						<tr>
							<td><a href="/../../../static/wiki/supplier_order.html">/mall/supplier_order</a></td>
							<td>获取供货商订单列表</td>
						</tr>
						<tr>
							<td><a href="/../../../static/wiki/supplier_delivery.html">/mall/delivery</a></td>
							<td>供货商发货通知</td>
						</tr>
					</tbody>
				</table>
			</div>
		)
	}
})
module.exports = ProductApiPage;