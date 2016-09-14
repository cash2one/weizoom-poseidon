/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:outline.datas:DatasPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

var CommentDialog = require('./CommentDialog.react');

require('./style.css');

var DatasPage = React.createClass({
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

	rowFormatter: function(field, value, data) {
		if (field === 'models') {
			var models = value;
			var modelEls = models.map(function(model, index) {
				return (
					<div key={"model"+index}>{model.name} - {model.stocks}</div>
				)
			});
			return (
				<div style={{color:'red'}}>{modelEls}</div>
			);
		} else if (field === 'name') {
			return (
				<a href={'/outline/data/?__memorize=1&id='+data.id}>{value}</a>
			)
		} else if (field === 'price') {
			return (
				<a onClick={this.onClickPrice} data-product-id={data.id}>{value}</a>
			)
		} else if (field === 'action') {
			return (
			<div>
				<a className="btn btn-link btn-xs" onClick={this.onClickDelete} data-product-id={data.id}>删除</a>
				<a className="btn btn-link btn-xs mt5" href={'/outline/data/?__memorize=1&id='+data.id}>编辑</a>
				<a className="btn btn-link btn-xs mt5" onClick={this.onClickComment} data-product-id={data.id}>备注</a>
			</div>
			);
		} else if (field === 'expand-row') {
			return (
				<div style={{paddingBottom:'20px'}}>
				<div className="clearfix" style={{backgroundColor:'#EFEFEF', color:'#FF0000', padding:'5px', borderBottom:'solid 1px #CFCFCF'}}>
					<div className="fl">促销结束日：{data.promotion_finish_time}</div>
					<div className="fr">总金额: {data.price}元</div>
				</div>
				</div>
			)
		} else {
			return value;
		}
	},

	render:function(){
		debug('render ...');
		var resource = {
			resource: 'outline.datas',
			data: {
				page: 1
			}
		};

		var locationOptions = [{
			text: '选择地域',
			value: -1
		}, {
			text: '北京',
			value: 'beijing'
		}, {
			text: '上海',
			value: 'shanghai'
		}, {
			text: '南京',
			value: 'nanjing'
		}];

		/*
		var defaultFilters = {
			name: '商品', //for FormInput
			weight: {
				low: '10',
				high: '20'
			}, //for FormRangeInput
			location: 'beijing', //for FormSelect
			promotion_finish_date: {
				low: '2016-07-25 13:11',
				high: ''
			} //for FormDateRangeInput
		};
		*/

		return (
		<div className="mt15 xui-outline-datasPage">
			<Reactman.FilterPanel onConfirm={this.onConfirmFilter}>
				<Reactman.FilterRow>
					<Reactman.FilterField>
						<Reactman.FormInput label="商品名:" name="name" match='~' />
					</Reactman.FilterField>
					<Reactman.FilterField>
						<Reactman.FormInput label="商品名2:" name="name2" match="=" />
					</Reactman.FilterField>
					<Reactman.FilterField>
						<Reactman.FormInput label="商品名3:" name="name3" match="=" />
					</Reactman.FilterField>
				</Reactman.FilterRow>

				<Reactman.FilterRow>
					<Reactman.FilterField>
						<Reactman.FormSelect label="地区:" name="location" options={locationOptions} match="=" />
					</Reactman.FilterField>
					<Reactman.FilterField>
						<Reactman.FormRangeInput label="重量:" name="weight" match="[]" />
					</Reactman.FilterField>
					<Reactman.FilterField>
					</Reactman.FilterField>
				</Reactman.FilterRow>

				<Reactman.FilterRow>
					<Reactman.FilterField>
						<Reactman.FormDateRangeInput label="促销结束:" name="promotion_finish_date" match="[t]" />
					</Reactman.FilterField>
				</Reactman.FilterRow>
			</Reactman.FilterPanel>

			<Reactman.TablePanel>
				<Reactman.TableActionBar>
					<Reactman.TableActionButton text="强制刷新" icon="refresh" onClick={this.onForceUpdate} />
					<Reactman.TableActionButton text="添加商品" icon="plus" href="/outline/data/" />
					<Reactman.TableActionButton text="批量删除" icon="remove" onClick={this.onClickBatchDelete} />
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
module.exports = DatasPage;