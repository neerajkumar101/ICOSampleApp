module.exports = function() {

    var home = function(req, res, callback) {
        this.services.userService.home(res, callback);
    }

    var setUpDeploy = function(req, res, callback) {
        this.services.userService.setUpDeploy(res, callback);
    }

    var setMaxSupply = function(req, res, callback) {
        this.services.userService.setMaxSupply(req, res, callback);
    }

    var setPricesForTokensPerEth = function(req, res, callback) {
        this.services.userService.setPricesForTokensPerEth(req, res, callback);
    }

    var getTokenBalance = function(req, res, callback) {
        this.services.userService.getTokenBalance(req, res, callback);
    }

    var getEtherBalance = function(req, res, callback) {
        this.services.userService.getEtherBalance(req, res, callback);
    }

    var buyTokensThroughEthers = function(req, res, callback) {
        this.services.userService.buyTokensThroughEthers(req, res, callback);
    }

    var payEthersToContract = function(req, res, callback) {
        this.services.userService.payEthersToContract(req, res, callback);
    }
    
    var sellTokensFrom = function(req, res, callback) {
        this.services.userService.sellTokensFrom(req, res, callback);
    }

    var sendTokens = function(req, res, callback) {
        this.services.userService.sendTokens(req, res, callback);
    }

    var mint = function(req, res, callback) {
        this.services.userService.mint(req, res, callback);
    }

    var transferTokens = function(req, res, callback) {
        this.services.userService.transferTokens(req, res, callback);
    }

    var approve = function(req, res, callback) {
        this.services.userService.approve(req, res, callback);
    }

    var transferTokensFrom = function(req, res, callback) {
        this.services.userService.transferTokensFrom(req, res, callback);
    }

    var increaseApproval = function(req, res, callback) {
        this.services.userService.increaseApproval(req, res, callback);
    }

    var decreaseApproval = function(req, res, callback) {
        this.services.userService.decreaseApproval(req, res, callback);
    }

    var allowance = function(req, res, callback) {
        this.services.userService.allowance(req, res, callback);
    }

    var burn = function(req, res, callback) {
        this.services.userService.burn(req, res, callback);
    }
    
    var setUpDeploy1 = function(req, res, callback) {
        this.services.userService.setUpDeploy1(res, callback);
    }

    var startFirstICOSale = function(req, res, callback) {
        this.services.userService.startFirstICOSale(res, callback);
    }

    var getSalesCount = function(req, res, callback) {
    //    callback(null, null);
        this.services.userService.getSalesCount(res, callback);
    }

    return {
        home: home,
        setUpDeploy: setUpDeploy,
        setMaxSupply: setMaxSupply,
        setPricesForTokensPerEth: setPricesForTokensPerEth,
        getTokenBalance: getTokenBalance,
        getEtherBalance: getEtherBalance,
        buyTokensThroughEthers: buyTokensThroughEthers,
        payEthersToContract: payEthersToContract,
        sellTokensFrom: sellTokensFrom,
        sendTokens: sendTokens,
        mint: mint,
        transferTokens: transferTokens,
        approve: approve,
        transferTokensFrom: transferTokensFrom,
        increaseApproval: increaseApproval,
        decreaseApproval: decreaseApproval,
        allowance: allowance,
        burn: burn,
        setUpDeploy1: setUpDeploy1,
        startFirstICOSale: startFirstICOSale,
        getSalesCount: getSalesCount
    }
};
