/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:outline.datas:AccountsPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

var CommentDialog = require('./CommentDialog.react');

require('./style.css');

var AccountsPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	onChangeStore: function(event) {
		var filterOptions = Store.getData().filterOptions;
		this.refs.table.refresh(filterOptions);
	},

	onClickDelete: function(event) {
		var productId = parseInt(event.target.getAttribute('data-product-id'));
		Reactman.PageAction.showConfirm({
			target: event.target, 
			title: '确认删除吗?',
			confirm: _.bind(function() {
				Action.deleteProduct(productId);
			}, this)
		});
	},

	onClickPrice: function(event) {
		var productId = parseInt(event.target.getAttribute('data-product-id'));
		var product = this.refs.table.getData(productId);

		Reactman.PageAction.showPopover({
			target: event.target,
			content: '<span style="color:red">' + product.name + ':' + product.price + '</span>'
		});
	},

	onClickComment: function(event) {
		var productId = parseInt(event.target.getAttribute('data-product-id'));
		var product = this.refs.table.getData(productId);
		Reactman.PageAction.showDialog({
			title: "创建备注", 
			component: CommentDialog, 
			data: {
				product: product
			},
			success: function(inputData, dialogState) {
				var product = inputData.product;
				var comment = dialogState.comment;
				Action.updateProduct(product, 'comment', comment);
			}
		});
	},

	onClickBatchDelete: function(event) {
		var ids = _.pluck(this.refs.table.getSelectedDatas(), 'id');
		alert('批量删除数据: ' + ids);
	},

	onConfirmFilter: function(data) {
		Action.filterProducts(data);
	},

	onBeforeLoadTable: function() {
		$(window).scrollTop(0);
	},

	onAfterLoadTable: function(data) {
		debug(data);
	},

	onForceUpdate: function(event) {
		this.setState(Store.getData());
		var filterOptions = Store.getData().filterOptions;
		this.refs.table.refresh(filterOptions);
	},

	render:function(){
		return (
		<div className="mt15 xui-customer-acountsPage">
			<div className="xui-default-box">
				<div className="xi-default-box">
					<span className="xi-default-box-status">待激活</span>
					<div className="xi-default-box-tips">
						<span style={{fontSize:'20px', fontWeight:'bold'}}>默认应用</span>
						<span style={{fontSize:'14px'}}>appid：激活后自动生成</span>
						<span style={{fontSize:'14px'}}>appsecret：激活后自动生成</span>
					</div>
					<div className="xi-default-box-acctive-btn">
						<a href="javascript:void(0);">立即激活</a>
					</div>
				</div>
			</div>
			<div className="xui-process-description">
				<span className="xi-process-description-span">流程说明</span>
				<div className="xui-process-description-div">
					<div className="xui-process-description-title">
						<span className="xi-number">1</span>
						<img src="/static/img/poseidon/circular.png"></img>
						<span className="xi-title" style={{fontSize: '18px'}}>激活应用</span>
						<img src="/static/img/poseidon/line.png" style={{width:'40%'}}></img>
					</div>
					<div className="xui-process-description-title">
						<span className="xi-number">2</span>
						<img src="/static/img/poseidon/circular.png"></img>
						<span className="xi-title" style={{fontSize: '18px'}}>应用审核</span>
						<img src="/static/img/poseidon/line.png" style={{width:'40%'}}></img>
					</div>
					<div className="xui-process-description-title">
						<span className="xi-number">3</span>
						<img src="/static/img/poseidon/circular.png"></img>
						<span className="xi-title" style={{fontSize: '18px'}}>接口联调</span>
					</div>
				</div>
			</div>
		</div>
		)
	}
})
module.exports = AccountsPage;