var fs = require('fs');
var Web3 = require('web3');

var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
  
// Token Contract's coinbase address
var coinbase = '0x0270a33e6ac28b8c1d444bb5eab3ad1d453e4d5f';

function setToken(next, deployed, Token, callback) {
    var hash = deployed.setToken.getData(Token);
    var transfer = deployed._eth.sendTransaction({ from: coinbase, to: deployed.address, data: hash })
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function setMaxSupply(deployed, maxSupply, callback) {
    var hash = deployed.setMaxSupply.getData(maxSupply);
    var transfer = deployed._eth.sendTransaction({ from: coinbase, to: deployed.address, data: hash })
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function setPricesForTokensPerEth(deployed, sellPrice, buyPrice, callback){
    var hash = deployed.setPricesForTokensPerEth.getData(sellPrice, buyPrice);
    var transfer = deployed._eth.sendTransaction({ from: coinbase, to: deployed.address, data: hash })
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function buyTokensThroughEthers(deployed, fromAccount, ethers, callback){
    var transactionHash = deployed.buyTokens.sendTransaction({ from: fromAccount, value: ethers});
    callback(null, transactionHash);
}

function payEthersToContract(deployed, fromAccount, ethers, callback){
    var hash = deployed.payEthersToContract.getData(fromAccount, ethers);
    var transfer = deployed._eth.sendTransaction({ from: coinbase, to: deployed.address, data: hash })
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function sellTokensFrom(deployed, fromAccount, tokens, callback){
    var transactionHash = deployed.sell.sendTransaction({ from: fromAccount, value: tokens});
    callback(null, transactionHash);
}

function sendTokens(deployed, fromAccount, targetAccount, tokens, callback){
    var hash = deployed.sendTokens.getData(fromAccount, targetAccount, tokens);
    var transfer = deployed._eth.sendTransaction({from: coinbase, to: deployed.address, data: hash});
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function mint(deployed, targetAccount, amount, callback){
    var hash = deployed.mint.getData(targetAccount, amount);
    var transfer = deployed._eth.sendTransaction({from: coinbase, to: deployed.address, data: hash});
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function transferTokens(deployed, targetAccount, amount, callback){
    var hash = deployed.transfer.getData(targetAccount, amount);
    var transfer = deployed._eth.sendTransaction({from: coinbase, to: deployed.address, data: hash});
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function approve(deployed, spenderContract, limitToSpend, callback){
    var hash = deployed.approve.getData(spenderContract, limitToSpend);
    var transfer = deployed._eth.sendTransaction({from: coinbase, to: deployed.address, data: hash});
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function increaseApproval(deployed, spenderContract, addedLimitToSpend, callback){
    var hash = deployed.increaseApproval.getData(spenderContract, addedLimitToSpend);
    var transfer = deployed._eth.sendTransaction({from: coinbase, to: deployed.address, data: hash});
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function decreaseApproval(deployed, spenderContract, reducedLimitToSpend, callback){
    var hash = deployed.decreaseApproval.getData(spenderContract, reducedLimitToSpend);
    var transfer = deployed._eth.sendTransaction({from: coinbase, to: deployed.address, data: hash});
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function transferTokensFrom(deployed, sourceAccount, targetAccount, amount, callback){
    var hash = deployed.transferFrom.getData(sourceAccount, targetAccount, amount);
    var transfer = deployed._eth.sendTransaction({from: coinbase, to: deployed.address, data: hash});
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function allowance(deployed, ownerAccount, spenderContract, callback){
    var remainingAllowance = deployed.allowance.call(ownerAccount, spenderContract);
    callback(null, remainingAllowance);
}

function burn(deployed, sourceAccount, amountToBurn, callback){
    var hash = deployed.burn.getData(sourceAccount, amountToBurn);
    var transfer = deployed._eth.sendTransaction({from: coinbase, to: deployed.address, data: hash});
    var transactionHash = {
        getData: hash,
        sendTransaction: transfer
    }
    callback(null, transactionHash);
}

function getTokenBalance(deployed, accountAddress, callback) {
    var tokenBal = deployed.getTokenBalance(accountAddress);
    callback(null, tokenBal); 
}

function getEtherBalance(accountAddress, callback) {
    if(accountAddress != 0x0) {
        var tokenBal = web3.eth.getBalance(accountAddress);
        callback(null, tokenBal); 
    }
}

function setAsTest(next, deployed, icoAddress) {
    var transfer = deployed.setAsTest.sendTransaction({ from: coinbase });
    var setAsTest = {
        getData: transfer
    }
    next(null, setAsTest)
}

function setController(next, deployed, icoAddress) {
    var hash = deployed.setController.getData(icoAddress);
    var transfer = deployed._eth.sendTransaction({ from: coinbase, to: deployed.address, data: hash })
    var setController = {
        getData: hash,
        sendTransaction: transfer
    }
    next(null, setController)
}

function setFirstSaleLauncher(next, deployed, icoAddress) {
    var hash = deployed.setFirstSaleLauncher.getData(icoAddress);
    var transfer = deployed._eth.sendTransaction({ from: coinbase, to: deployed.address, data: hash })
    var setFirstSaleLauncher = {
        getData: hash,
        sendTransaction: transfer
    }
    next(null, setFirstSaleLauncher)
}

function setAuctionLauncher(next, deployed, icoAddress) {
    var hash = deployed.setAuctionLauncher.getData(icoAddress);
    var transfer = deployed._eth.sendTransaction({ from: coinbase, to: deployed.address, data: hash })
    var setAuctionLauncher = {
        getData: hash,
        sendTransaction: transfer
    }
    next(null, setAuctionLauncher)
}

function setAdvisor(next, deployed, icoAddress) {
    var hash = deployed.setAdvisor.getData(icoAddress);
    var transfer = deployed._eth.sendTransaction({ from: coinbase, to: deployed.address, data: hash })
    var setAdvisor = {
        getData: hash,
        sendTransaction: transfer
    }
    next(null, setAdvisor)
}

function sendTransaction(next, from, to, smartContractAddress, contractInstance) {
    async.auto({
        getData: function(nextAgain) {
            getData(nextAgain, smartContractAddress);
        },
        tranfer: ['getData', function(results, nextAgain) {
            tranfer(nextAgain, from, to, smartContractAddress, contractInstance, results.getData);
        }]

    }, function(err, success) {
        console.log("success", success)
        if (err) {
            console.log("error")
            next(err, null);
        } else {
            console.log("success")
            next(null, success);
        }
    });
}

function setFakeTime(next, deployed) {
    var transfer = deployed.setFakeTime.call('1');
    var setFakeTime = {
        sendTransaction: transfer
    }
    next(null, setFakeTime);
}

function getData(nextAgain, smartContractAddress, contractInstance) {
    var hash = contractInstance.getData(smartContractAddress)
    console.log(hash, "getData")
    nextAgain(null, hash)
}

function tranfer(nextAgain, from, to, smartContractAddress, contractInstance, data) {
    var hash = nextAgain._eth.sendTransaction({ from: from, to: to, data: data })
    console.log(hash, "tranfer")
    nextAgain(null, hash)
}

var unlockAccount = function(owner, password) {
    return new Promise((resolve, reject) => {
        var unlockFlag = web3.personal.unlockAccount(owner, password);
        if (unlockFlag) {
            resolve(unlockFlag);
        } else {
            reject(unlockFlag);
        }
    });
}

var deployExistingSmartContract = (next, smartContractAddress, contractName, callback) => {
    var promOb = new Promise((resolve, reject) => {
        // fs.readFile(__dirname + '/../contractsJson/' + contractName + '.json', 'utf8', function(error, abiRetrieved) {
        fs.readFile(__dirname + '/../../../build/contracts/' + contractName + '.json', 'utf8', function(error, abiRetrieved) {            
            if (error) {
                console.log("error in reading abi file: ", error);
                reject(error);
                // next(error, null);
            } else {
                console.log(abiRetrieved, "abiRetrieved")
                    // var unlockProm = unlockAccount('0x7de3e5981305f6c8871b8ed0fcefafc2787db074', '12345');
                    // unlockProm.then(() => {

                //     // callback(null, contractInstance);
                //     resolve(contractInstance);
                //     next(null, contractInstance)
                // }).catch((error) => {
                //     console.log('unlock inside deployexistingcontract error is here');
                //     console.log(error);
                //     return;
                // });

                var abiJson = JSON.parse(abiRetrieved);
                myContract = web3.eth.contract(abiJson.abi);
                var contractInstance = myContract.at(smartContractAddress);
                
                console.log('===============================================================');
                console.log(contractInstance);
                console.log('===============================================================');
                
                resolve(null, contractInstance); // useful only when someone handles the promise itself
                callback(null, contractInstance); // we are only handling through callbacks
            }
        });
    });
    return promOb;
}

module.exports = {
    setToken: setToken,
    setMaxSupply: setMaxSupply,
    setPricesForTokensPerEth: setPricesForTokensPerEth,
    buyTokensThroughEthers: buyTokensThroughEthers,
    payEthersToContract: payEthersToContract,
    sellTokensFrom: sellTokensFrom,
    sendTokens: sendTokens,
    mint: mint,
    transferTokens: transferTokens,
    approve: approve,
    increaseApproval: increaseApproval,
    decreaseApproval: decreaseApproval,
    transferTokensFrom: transferTokensFrom,
    allowance: allowance,
    burn: burn,
    getTokenBalance: getTokenBalance,
    getEtherBalance: getEtherBalance,
    setAsTest: setAsTest,
    setController: setController,
    setFirstSaleLauncher: setFirstSaleLauncher,
    setAuctionLauncher: setAuctionLauncher,
    setAdvisor: setAdvisor,
    sendTransaction: sendTransaction,
    setFakeTime: setFakeTime,
    getData: getData,
    tranfer: tranfer,
    unlockAccount: unlockAccount,
    deployExistingSmartContract: deployExistingSmartContract
};