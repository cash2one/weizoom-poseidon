'use strict';

var path = require('path');
var UglifyJsPlugin = require("./node_modules/webpack/lib/optimize/UglifyJsPlugin");

module.exports = {
	entry: {
		dev: [
			'webpack/hot/only-dev-server',
			'webpack-dev-server/client?http://localhost:4199',
			path.resolve(__dirname, 'static/index.js')
		],
		dist: [
			path.resolve(__dirname, 'static/index.js')
		]
	},
	output: {
		path: path.resolve(__dirname, 'static/build'),
		filename: 'bundle.js',
		publicPath: '/static/'
	},
	resolve: {
        alias: {
            dynamicRequire: 'dynamic_require'
        },
        root: [path.resolve(__dirname, './static/component')]
    },
	module: {
		loaders: [{
			test: /\.jsx?$/,
			loader: 'babel-loader',
			exclude: ['*.py', '*.pyc', 'templates']
		}, {
			test: /\.css$/, // Only .css files
			loader: 'style!css' // Run both loaders
		},{
			test: /\.html$/,
			loader: 'raw'
		}]
	},
	plugins: [
        //使用丑化js插件
        new UglifyJsPlugin({
            compress: {
                warnings: false
            },
            mangle: {
                except: ['window', '$']
            }
        })
    ],
    node: {
    	fs: "empty"
    }
};
