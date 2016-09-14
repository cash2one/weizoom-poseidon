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
		debug('render ...');
		var resource = {
			resource: 'outline.datas',
			data: {
				page: 1
			}
		};

		return (
		<div className="mt15 xui-outline-datasPage">
			<Reactman.TablePanel>
				<Reactman.TableActionBar>
					
				</Reactman.TableActionBar>
				<Reactman.Table 
					resource={resource} 
					formatter={this.rowFormatter} 
					pagination={true} 
					expandRow={true} 
					enableSelector={true} 
					ref="table"
					onBeforeLoad={this.onBeforeLoadTable}
					onAfterLoad={this.onAfterLoadTable}
				>
					<Reactman.TableColumn name="#" field="index" width="40px" />
					<Reactman.TableColumn name="商品" field="name" />
					<Reactman.TableColumn name="重量" field="weight" width="60px"/>
					<Reactman.TableColumn name="备注" field="comment" width="150px"/>
					<Reactman.TableColumn name="价格" field="price" width="80px" />
					<Reactman.TableColumn name="规格" field="models" width="100px" />
					<Reactman.TableColumn name="创建日" field="created_at" width="160px" />
					<Reactman.TableColumn name="操作" field="action" width="80px" />
				</Reactman.Table>
			</Reactman.TablePanel>
		</div>
		)
	}
})
module.exports = AccountsPage;