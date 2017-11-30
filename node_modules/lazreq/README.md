lazreq
======
Lazy require implementation


# Goal
Load modules only when they are actually needed WHILE keeping dependencies
listed on top of your files

# Why
In a bigger project with a lot of modules or with big modules, initialization
time may get increased if all modules get loaded and parsed before they are
needed or even without them being needed at all (like conditionally used
modules)

# How to
## Install
    npm install lazreq
## Use
### JavaScript
    var req = require('lazreq')({
      fs: 'fs',
      myLib: './lib/my-lib.js'
    });

    module.exports = function () {
      req.fs.exists('file_to_check.txt', function (exists) {
        if (exists) {
          req.myLib.amazingStuff();
        }
      });
    }
### CoffeeScript
    req = require('lazreq')
      fs:    'fs'
      myLib: './lib/my-lib.js'

    module.exports = ->
      req.fs.exists 'file_to_check.txt', (exists) ->
        if exists
          req.myLib.amazingStuff();

# FAQ
## How it works
It creates getters (using JavaScript standard standard Object.defineProperty
methods) that will trigger loading modules on first read and return cached
modules from the second read on

## How do relative pathes work?
Just the way you would expect from `require()`: node_modules and pathes starting
with './' or '../' will be looked up relative to the module file requiring them.
