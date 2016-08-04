/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:config.permissions:PermissionsPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

var Reactman = require('reactman');

var Action = require('./Action');

var PermissionsPage = React.createClass({
	onClickDelete: function(event) {
		var id = parseInt(event.target.getAttribute('data-id'));
		Reactman.PageAction.showConfirm({
			target: event.target, 
			title: '确认删除吗?',
			confirm: _.bind(function() {
				Action.deletePermission(id, this.refs.table.refresh);
			}, this)
		});
	},

	rowFormatter: function(field, value, data) {
		if (field === 'action') {
			return (
			<div>
				<a className="btn btn-link btn-xs" onClick={this.onClickDelete} data-id={data.id}>删除</a>
			</div>
			);
		} else {
			return value;
		}
	},

	render:function(){
		var permissionsResource = {
			resource: 'config.permissions',
			data: {
				page: 1
			}
		};

		return (
		<div className="mt15 xui-config-permissionsPage">
			<Reactman.TablePanel>
				<Reactman.TableActionBar>
					<Reactman.TableActionButton text="添加权限" icon="plus" href="/config/permission/" />
				</Reactman.TableActionBar>
				<Reactman.Table resource={permissionsResource} formatter={this.rowFormatter} pagination={true} ref="table">
					<Reactman.TableColumn name="#" field="index" width="40px" />
					<Reactman.TableColumn name="权限" field="name" />
					<Reactman.TableColumn name="codename" field="codename" />
					<Reactman.TableColumn name="操作" field="action" width="80px" />
				</Reactman.Table>
			</Reactman.TablePanel>
		</div>
		)
	}
})
module.exports = PermissionsPage;