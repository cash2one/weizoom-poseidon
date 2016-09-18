/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:application_audit.applications:ApplicationsPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

//var CommentDialog = require('./CommentDialog.react');

require('./style.css');

var ApplicationsPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	// onClickChangeStatus: function(event) {
	// 	var userId = parseInt(event.target.getAttribute('data-user-id'));
	// 	Reactman.PageAction.showConfirm({
	// 		target: event.target,
	// 		title: '确认开启该账号吗?',
	// 		confirm: _.bind(function() {
	// 			Action.changeUserStatus(userId, this.refs.table.refresh);
	// 		}, this)
	// 	});
	// },

	// onClickDelete: function(event) {
	// 	var userId = parseInt(event.target.getAttribute('data-user-id'));
	// 	Reactman.PageAction.showConfirm({
	// 		target: event.target, 
	// 		title: '确认删除吗?',
	// 		confirm: _.bind(function() {
	// 			Action.deleteUser(userId, this.refs.table.refresh);
	// 		}, this)
	// 	});
	// },

	onChangeStore: function(event) {
		var filterOptions = Store.getData().filterOptions;
		this.refs.table.refresh(filterOptions);
	},

	rowFormatter: function(field, value, data) {
		if (field === 'name') {
			return (
				<a href={'/config/user/?id='+data.id}>{value}</a>
			)
		} else if (field === 'action') {
			if(data.status == 1){
				return (
					<div>
						<a className="btn btn-link btn-xs" onClick={this.onClickChangeStatus} data-user-id={data.id}>关闭</a>
						<a className="btn btn-link btn-xs" href={'/config/user/?id='+data.id}>编辑</a>
					</div>
				);
			}else{
				return (
					<div>
						<a className="btn btn-link btn-xs" onClick={this.onClickDelete} data-user-id={data.id}>删除</a>
						<a className="btn btn-link btn-xs" href={'/config/user/?id='+data.id}>编辑</a>
					</div>
				);
			}
		} else {
			return value;
		}
	},

	onConfirmFilter: function(data) {
		Action.filterUser(data);
	},

	render:function(){
		var usersResource = {
			resource: 'application_audit.applications',
			data: {
				page: 1
			}
		};

		return (
		<div className="mt15 xui-config-usersPage">
			<Reactman.FilterPanel onConfirm={this.onConfirmFilter}>
				<Reactman.FilterRow>
					<Reactman.FilterField>
						<Reactman.FormInput label="登录名:" name="username" match='~' />
					</Reactman.FilterField>
					<Reactman.FilterField>
						<Reactman.FormInput label="主体名称:" name="displayName" match='~' />
					</Reactman.FilterField>
				</Reactman.FilterRow>
			</Reactman.FilterPanel>

			<Reactman.TablePanel>
				<Reactman.TableActionBar>
				</Reactman.TableActionBar>
				<Reactman.Table resource={usersResource} formatter={this.rowFormatter} pagination={true} ref="table">
					<Reactman.TableColumn name="应用名称" field="appName" />
					<Reactman.TableColumn name="app_id" field="appId"/>
					<Reactman.TableColumn name="app_secret" field="appSecret"/>
					<Reactman.TableColumn name="开发者姓名" field="DeveloperName"/>
					<Reactman.TableColumn name="手机号" field="phone"/>
					<Reactman.TableColumn name="邮箱" field="mail"/>
					<Reactman.TableColumn name="服务器IP" field="ip"/>
					<Reactman.TableColumn name="回调地址" field="address"/>
					<Reactman.TableColumn name="操作" field="action" width="100px" />
				</Reactman.Table>
			</Reactman.TablePanel>
		</div>
		)
	}
})
module.exports = ApplicationsPage;