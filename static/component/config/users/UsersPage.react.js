/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.users:UsersPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

//var CommentDialog = require('./CommentDialog.react');

require('./style.css');

var UsersPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	onClickDelete: function(event) {
		var userId = parseInt(event.target.getAttribute('data-user-id'));
		Reactman.PageAction.showConfirm({
			target: event.target, 
			title: '确认删除吗?',
			confirm: _.bind(function() {
				Action.deleteUser(userId, this.refs.table.refresh);
			}, this)
		});
	},

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
						<a className="btn btn-link btn-xs" onClick={this.onClickDelete} data-user-id={data.id}>关闭</a>
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
		Action.filterProducts(data);
	},

	render:function(){
		var usersResource = {
			resource: 'config.users',
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
				</Reactman.FilterRow>
			</Reactman.FilterPanel>

			<Reactman.TablePanel>
				<Reactman.TableActionBar>
					<Reactman.TableActionButton text="添加用户" icon="plus" href="/config/user/" />
				</Reactman.TableActionBar>
				<Reactman.Table resource={usersResource} formatter={this.rowFormatter} pagination={true} ref="table">
					<Reactman.TableColumn name="登录名" field="username" />
					<Reactman.TableColumn name="主体名称" field="displayName"/>
					<Reactman.TableColumn name="创建时间" field="createdAt" width="160px" />
					<Reactman.TableColumn name="应用状态" field="AppStatus" width="100px" />
					<Reactman.TableColumn name="操作" field="action" width="100px" />
				</Reactman.Table>
			</Reactman.TablePanel>
		</div>
		)
	}
})
module.exports = UsersPage;