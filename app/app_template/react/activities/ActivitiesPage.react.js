/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

__STRIPPER_TAG__
var debug = require('debug')('m:app.{{resource.lower_name}}:activities:ActivitiesPage');
var React = require('react');
var ReactDOM = require('react-dom');
var _ = require('underscore');

__STRIPPER_TAG__
var Reactman = require('reactman');

__STRIPPER_TAG__
var Store = require('./Store');
var Constant = require('./Constant');
var Action = require('./Action');

__STRIPPER_TAG__
require('./style.css');

__STRIPPER_TAG__
var ActivitiesPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	__STRIPPER_TAG__
	onClickDeleteActivity: function(event) {
		var id = event.target.getAttribute('data-id');
		Reactman.PageAction.showConfirm({
			target: event.target, 
			title: '确认删除吗?',
			confirm: _.bind(function() {
				Action.deleteActivity(id);
			}, this)
		});
	},

	__STRIPPER_TAG__
	onClickCloseActivity: function(event) {
		var id = event.target.getAttribute('data-id');
		Reactman.PageAction.showConfirm({
			target: event.target, 
			title: '确认关闭活动吗?',
			confirm: _.bind(function() {
				Action.closeActivity(id);
			}, this)
		});
	},

	__STRIPPER_TAG__
	onClickShowLink: function(event) {
		var id = event.target.getAttribute('data-id');
		var url = 'http://127.0.0.1:3080/{{service_name}}-ui-service/operation_app_activity/activity/?id='+id;
		var cContent = (<CopyLinkPopover url={url} />);
		
		Reactman.PageAction.showPopover({
			title: '拷贝链接',
			target: event.target,
			reactComponent: cContent,
			width: 270
		});
	},

	__STRIPPER_TAG__
	onConfirmFilter: function(data) {
		Action.filterActivities(data);
	},

	__STRIPPER_TAG__
	onChangeStore: function(event) {
		var filterOptions = Store.getData().filterOptions;
		this.refs.table.refresh(filterOptions);
	},

	__STRIPPER_TAG__
	rowFormatter: function(field, value, data) {
		if (field === 'name') {
			return (
				<a href={'/app/{{app_name}}/activity/?id='+data.id}>{value}</a>
			)
		} else if (field === 'status') {
			if (value === '未开始') {
				return (<span className="label label-default">未开始</span>);
			} else if (value === '进行中') {
				return (<span className="label label-success">进行中</span>);
			} else if (value === '已结束') {
				return (<span className="label label-primary">已结束</span>);
			}
		} else if (field === 'action') {
			var cCloseLink = void(0);
			if (data.status === '进行中') {
				cCloseLink = (<a className="btn btn-link btn-xs" onClick={this.onClickCloseActivity} data-id={data.id}>关闭</a>);
			}

			var cDeleteLink = void(0);
			if (data.status === '已结束') {
				cDeleteLink = (<a className="btn btn-link btn-xs" onClick={this.onClickDeleteActivity} data-id={data.id}>删除</a>)
			}

			return (
			<div>
				{cCloseLink}
				{cDeleteLink}
				<a className="btn btn-link btn-xs" onClick={this.onClickShowLink} data-id={data.id}>链接</a>
				<a className="btn btn-link btn-xs" href={'/app/{{app_name}}/activity/?id='+data.id}>预览</a>
				<a className="btn btn-link btn-xs" href='#'>统计</a>
				<a className="btn btn-link btn-xs" href={'/app/{{app_name}}/activity_participances/?id'+data.id}>查看结果</a>
			</div>
			);
		} else {
			return value;
		}
	},

	__STRIPPER_TAG__
	render:function(){
		var resource = {
			resource: 'app.{{app_name}}.activities',
			data: {
				page: 1
			}
		};

		__STRIPPER_TAG__
		var statusOptions = [{
			text: '全部',
			value: '-1'
		}, {
			text: '未开始',
			value: '0'
		}, {
			text: '进行中',
			value: '1'
		}, {
			text: '已结束',
			value: '2'
		}];

		__STRIPPER_TAG__
		var prizeOptions = [{
			text: '所有奖品',
			value: 'all',
		}, {
			text: '优惠券',
			value: 'coupon'
		}, {
			text: '积分',
			value: 'integral'
		}];

		__STRIPPER_TAG__
		return (
		<div className="mt15 xui-app-{{app_name}}-activitiesPage">
			<Reactman.FilterPanel onConfirm={this.onConfirmFilter}>
				<Reactman.FilterRow>
					<Reactman.FilterField>
						<Reactman.FormInput label="活动名称:" name="name" match='~' />
					</Reactman.FilterField>
					<Reactman.FilterField>
						<Reactman.FormSelect label="状态:" name="status" options={statusOptions} match="=" />
					</Reactman.FilterField>
					<Reactman.FilterField>
						<Reactman.FormSelect label="奖项:" name="prize" options={prizeOptions} match="=" />
					</Reactman.FilterField>
				</Reactman.FilterRow>

				__STRIPPER_TAG__
				<Reactman.FilterRow>
					<Reactman.FilterField>
						<Reactman.FormDateRangeInput label="活动时间:" name="active_date_range" match="[t]" />
					</Reactman.FilterField>
				</Reactman.FilterRow>
			</Reactman.FilterPanel>

			__STRIPPER_TAG__
			<Reactman.TablePanel>
				<Reactman.TableActionBar>
					<Reactman.TableActionButton text="添加活动" icon="plus" href="/app/{{app_name}}/activity/" />
				</Reactman.TableActionBar>
				<Reactman.Table resource={resource} formatter={this.rowFormatter} pagination={true} ref="table">
					<Reactman.TableColumn name="#" field="index" width="40px" />
					<Reactman.TableColumn name="活动" field="name" />
					<Reactman.TableColumn name="参与人数" field="participantCount" width="80px" />
					<Reactman.TableColumn name="开始时间" field="startTime" width="140px" />
					<Reactman.TableColumn name="结束时间" field="endTime" width="140px" />
					<Reactman.TableColumn name="状态" field="status" width="60px"/>
					<Reactman.TableColumn name="操作" field="action" width="230px" />
				</Reactman.Table>
			</Reactman.TablePanel>
		</div>
		)
	}
})
module.exports = ActivitiesPage;