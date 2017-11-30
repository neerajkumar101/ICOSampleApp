#!/usr/bin/env coffee


req = require('../js/lazreq')
  fs:   'fs'
  test: './test-module'


unless typeof req.fs.readFileSync is 'function' and req.test.foundMe is true
  process.exit 1
