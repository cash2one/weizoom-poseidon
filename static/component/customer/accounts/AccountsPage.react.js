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
var W = Reactman.W;

require('./style.css');

var AccountsPage = React.createClass({
	getInitialState: function() {
		Store.addListener(this.onChangeStore);
		return Store.getData();
	},

	onChangeStore: function(event) {
		var datas = Store.getData();
		console.log(datas,"=======")
		this.setState(Store.getData());
	},

	editMessage: function(){
		var customerId = this.state.customerId;
		W.gotoPage('/customer/messages/?customer_id='+customerId);
	},

	componentWillMount: function(){
		if(W.customerStatus != 0) {
			Action.getCustomerStatus();
		}
	},

	render:function(){
		var customerStatus = this.state.status;
		var reviewTime = this.state.reviewTime;
		var appId = this.state.appId;
		var appSecret = this.state.appSecret;
		var serverIp = this.state.serverIp;
		var interfaceUrl = this.state.interfaceUrl;
		var statusTitle = '待激活';
		var statusBtn = '';
		var resultText = '';
		var style = {}
		style = {color: '#FF6600'};

		if(customerStatus == 1 ) {
			statusTitle = '审核中';
			statusBtn = <a href="javascript:void(0);" style={{display:'inline-block', width:'100%'}}>审核中</a>;
		}else if(customerStatus == 2){
			statusTitle = '已激活';
			resultText = '应用激活审核通过，可以正常使用；';
			style = {color: '#51B9B6'};
		}else if(customerStatus == 3) {
			var reason = this.state.reason;
			statusTitle = '已驳回';
			resultText = '应用激活申请被驳回，' + reason;
			appId = '激活后自动生成';
			appSecret = '激活后自动生成';
			statusBtn = <a href="javascript:void(0);" style={{display:'inline-block', width:'100%'}} onClick={this.editMessage}>重新修改并激活</a>;
		}else if(customerStatus == 4) {
			statusTitle = '已停用';
			resultText = '应用已暂停使用';
		}else{
			statusBtn = <a href="javascript:void(0);" style={{display:'inline-block', width:'100%'}} onClick={this.editMessage}>立即激活</a>;
		}

		if(customerStatus == 2 || customerStatus == 3 || customerStatus == 4){
			return (
				<div className="mt15 xui-customer-acountsPage">
					<div className="xui-default-box">
						<div className="xi-default-box">
							<span className="xi-default-box-status" style={style}>{statusTitle}</span>
							<div className="xi-default-box-tips">
								<div style={{width:'25%', textAlign:'center', display:'inline-block'}}>
									<span style={{fontSize:'20px', fontWeight:'bold'}}>默认应用</span>
									<span className="xi-app-id" style={{fontSize:'14px'}}>appid：{appId}</span>
									<span className="xi-app-secret" style={{fontSize:'14px'}}>appsecret：{appSecret}</span>
								</div>
								<div className="xi-split-line"></div>
								<div className="xi-messages-ip-url">
									<span className="xi-server-ip">服务器IP：{serverIp}</span>
									<span className="xi-interface-url">接口回调地址：{interfaceUrl}</span>
								</div>
								{
									customerStatus == 3 ?
										<div className="xi-default-box-modify-btn">
											{statusBtn}
										</div>
									: ''
								}
							</div>
						</div>
					</div>
					<div style={{clear: 'both'}}></div>
					<div className="xui-apply-record">
						<span style={{display: 'block', fontWeight:'bold'}}>审核记录</span>
						<span className="xi-time">{reviewTime}</span>
						<span className="xi-result">{resultText}</span>
					</div>
				</div>
				)
		}

		return (
		<div className="mt15 xui-customer-acountsPage">
			<div className="xui-default-box">
				<div className="xi-default-box">
					<span className="xi-default-box-status">{statusTitle}</span>
					<div className="xi-default-box-tips">
						<div style={{width:'25%', textAlign:'center', display:'inline-block'}}>
							<span style={{fontSize:'20px', fontWeight:'bold'}}>默认应用</span>
							<span style={{fontSize:'14px'}}>appid：激活后自动生成</span>
							<span style={{fontSize:'14px'}}>appsecret：激活后自动生成</span>
						</div>
					</div>
					<div className="xi-default-box-acctive-btn">
						{statusBtn}
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