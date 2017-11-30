 global.express = require('express');
 global.mongoose = require('mongoose');
 global._ = require('underscore');
 global.async = require('async');
 global.errorHandler = require('errorhandler')
     // global.mongooseSchema = mongoose.Schema;
 global.dbConnection = require('./Datasource.js').getDbConnection();
 global.configurationHolder = {};
 configurationHolder.config = require('./Conf.js').configVariables();
 configurationHolder.http = require('../application-middlewares/HttpCaller').HttpCaller;
     //Application specific intial program to execute when server starts
 configurationHolder.Bootstrap = require('./Bootstrap.js');
     
//  // Application specific security authorization middleware
//      configurationHolder.security = require('../application-middlewares/AuthorizationMiddleware').AuthorizationMiddleware
 
     //UTILITY CLASSES
 global.url = require('../application-utilities/Domainurlapi.js').url;


 module.exports = configurationHolder;
