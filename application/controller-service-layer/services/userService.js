var BaseService = require('./BaseService');
var functions = require('./functions.js');

var Token = '0x05836d5d5612675a7e90be47297b409b98d10e86';
var TokenController = '0x3cd64c28233c61870b159beae0946b8ddbf2d553';

//================== Global Variable for holding Smart Contract Instances =========
global.TokenContract;
global.TokenControllerContract;
//=================================================================================

userService = function(app) {
    this.app = app;
};

userService.prototype = new BaseService();

userService.prototype.home = function(res, callback) {
    res.send('NodeJS demo app by Neeraj Kumar Rajput.');
    callback(null, null);
}

userService.prototype.setUpDeploy = function(res, callback) {
    async.auto({
        TokenSmartContractInstance: function(next) {
            functions.deployExistingSmartContract(next, Token, 'Token', function(error, result){
                if(error != undefined){
                    res.send(error);
                } else {
                    global.TokenContract = result;
                    next(null, result);
                }
            });
        },
        TokenControllerSmartContractInstance: ['TokenSmartContractInstance', function(results, next) {
            functions.deployExistingSmartContract(next, TokenController, 'TokenController', function(error, result){
                if(error != undefined){
                    res.send(error);
                } else {
                    global.TokenControllerContract = result;                    
                    next(null, result);                    
                }
            });
        }],
        SetToken: ['TokenControllerSmartContractInstance', function(results, next) {
            functions.setToken(next, results.TokenControllerSmartContractInstance, Token, function(error, result){
                if(error != undefined){
                    res.send(error);
                } else {
                    next(null, result);                    
                }
            });
        }]
    }, function(err, success) {
        console.log("success", success)
        if (err) {
            console.log("error")
            callback(err, null);
        } else {
            console.log("success")
            callback(null, success);
        }
    });
}

userService.prototype.setMaxSupply = function(req, res, callback) {
    functions.setMaxSupply(global.TokenContract, req.body.maxSupply, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfully set the maxSupply' + result);
        }
    });
}

userService.prototype.setPricesForTokensPerEth = function(req, res, callback) {
    functions.setPricesForTokensPerEth(global.TokenControllerContract, req.body.sellPrice, req.body.buyPrice, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfully set the buy price and sell price ' + result);
        }
    });
}

userService.prototype.getTokenBalance = function(req, res, callback) {
    functions.getTokenBalance(global.TokenContract, req.body.address, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Token balance of account address {'+ req.body.address+ '} is: ' + result);
        }
    });
}

userService.prototype.getEtherBalance = function(req, res, callback) {
    functions.getEtherBalance(req.body.address, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Ether balance of account address {'+ req.body.address+ '} is: ' + (result / 1000000000000000000) + ' Ether' );
        }
    });
}

userService.prototype.buyTokensThroughEthers = function(req, res, callback) {
    functions.buyTokensThroughEthers(global.TokenControllerContract, req.body.sourceAccount, req.body.ethers, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.payEthersToContract = function(req, res, callback) {
    functions.payEthersToContract(global.TokenControllerContract, req.body.sourceAccount, req.body.ethers, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.sellTokensFrom = function(req, res, callback) {
    functions.sellTokensFrom(global.TokenControllerContract, req.body.sourceAccount, req.body.tokens, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.sendTokens = function(req, res, callback) {
    functions.sendTokens(global.TokenContract, req.body.sourceAccount, req.body.targetAccount, req.body.tokens, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.mint = function(req, res, callback) {
    functions.mint(global.TokenContract, req.body.targetAccount, req.body.amount, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.transferTokens = function(req, res, callback) {
    functions.transferTokens(global.TokenContract, req.body.targetAccount, req.body.amount, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.approve = function(req, res, callback) {
    functions.approve(global.TokenContract, req.body.spenderContract, req.body.limitToSpend, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.increaseApproval = function(req, res, callback) {
    functions.increaseApproval(global.TokenContract, req.body.spenderContract, req.body.addedLimitToSpend, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.decreaseApproval = function(req, res, callback) {
    functions.decreaseApproval(global.TokenContract, req.body.spenderContract, req.body.reducedLimitToSpend, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.allowance = function(req, res, callback) {
    functions.allowance(global.TokenContract, req.body.ownerAccount, req.body.spenderContract, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.transferTokensFrom = function(req, res, callback) {
    functions.transferTokensFrom(global.TokenControllerContract, req.body.sourceAccount, req.body.targetAccount, req.body.amount, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.burn = function(req, res, callback) {
    functions.burn(global.TokenContract, req.body.sourceAccount, req.body.amountToBurn, function(error, result){
        if(error != undefined){
            res.send(error);
        } else {
            res.send('Successfull hash: ' + result);
        }
    });
}

userService.prototype.startFirstICOSale = function(res, callback) {
    // ICOControllerMonolith.deployed().then(function(deployed) { deployed.startFirstSale.sendTransaction(100).then(function(hash) { console.log(hash) }) });
    async.auto({
        ICOControllerMonolithSmartContractInstance: function(next) {
            functions.deployExistingSmartContract(next, ICO, 'ICO');
        },
        StartSale: ['ICOControllerMonolithSmartContractInstance', function(results, next) {
            var deployed = results.ICOControllerMonolithSmartContractInstance;
            // deployed.startFirstSale.call('100');
            // var hash = deployed.startFirstSale.getData('100');
            // console.log(deployed.setAuctionLauncher.getData(icoAddress));
            var transfer = deployed.startFirstSale.call(100)
            next(null, "StartSale done")
        }],
    }, function(err, success) {
        console.log(success, "success")
        if (err) {
            console.log("error")
            callback(err, null);
        } else {
            console.log("success")
            callback(null, success);
        }
    });
}

module.exports = function(app) {
    return new userService(app);
};