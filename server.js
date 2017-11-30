global.cors = require('cors');
global.dash = require('appmetrics-dash');
dash.attach();
var express = require('express');
console.log("cors is already running")
var mongoose = require('mongoose');
var bodyParser = require('body-parser');
var multipart = require('connect-multiparty');

global.crypto = require('crypto');
global.multipartMiddleware = multipart();
global.app = module.exports = express();
global.errorHandler = require('errorhandler');
global.publicdir = __dirname;
global.async = require('async');
global.path = require('path')
global.router = express.Router();
global.uuid = require('node-uuid');
global.mongooseSchema = mongoose.Schema;
global.configurationHolder = require('./configurations/DependencyInclude.js');
global.domain = require('./configurations/DomainInclude.js');

console.log("configurationHolder", configurationHolder.Bootstrap)
app.use(errorHandler());
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept,X-Auth-Token");
    next();
});
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
    // app.use(express.static(__dirname + '../ngcourse-admin'))

Layers = require('./application-utilities/layers').Express;
var wiring = require('./configurations/UrlMapping');
new Layers(app, router, __dirname + '/application/controller-service-layer', wiring);

configurationHolder.Bootstrap.initApp()
