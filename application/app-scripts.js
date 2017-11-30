//============================================ Initial Setup ================================================
Token.deployed().then(function(deployed){deployed.setMaxSupply.sendTransaction('1000000000000000000000000000').then(function(data){console.log(data)} ).catch(function(error){console.log('here is: ' + error)}) } );

TokenController.deployed().then(function(deployed){deployed.setToken.sendTransaction(Token.address).then(function(data){console.log(data)} ) } );

TokenController.deployed().then(function(deployed){deployed.setPricesForTokensPerEth.sendTransaction(10000, 10100).then(function(data){console.log(data)} ) } );

web3.personal.unlockAccount(web3.eth.accounts[1], 'oodles', 0)
TokenController.deployed().then(function(deployed){deployed.sendTransaction({ from: web3.eth.accounts[1], value: '10000000000000000000'}).then(function(data){console.log(data)} ).catch(function(error){console.log('here is: ' + error)}) } );

//=============================================== checking balances =======================================================================
//to get the ethereum balance
web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]), 'ether')
//to get the token balance of any account
Token.deployed().then(function(deployed){deployed.getTokenBalance(web3.eth.accounts[1]).then(function(data){console.log(data)} ) } )

//=================================================================================================================================
TokenController.deployed().then(function(deployed){deployed.payEthersToContract.sendTransaction({ from: web3.eth.accounts[0], value: '120000000000000000000'}).then(function(data){console.log(data)} ).catch(function(error){console.log('here is: ' + error)}) } );

TokenController.deployed().then(function(deployed){deployed.sell.sendTransaction({from : web3.eth.accounts[1], value: '1010000'}).then(function(data){console.log(data)} ).catch(function(error){console.log('here is: ' + error)}) } );

//============================================================================================================================

Token.deployed().then(function(deployed){deployed.sendTokens.sendTransaction(web3.eth.accounts[1], web3.eth.accounts[0], '106050').then(function(data){console.log(data)} ).catch(function(error){console.log('here is: ' + error)}) } );

//requesting approval for sending tokens in transferFrom() in return of recieved ethers
Token.deployed().then(function(deployed){deployed.approve(TokenController.address, '106050').then(function(data){console.log(data)} ) } )
//test allowance
Token.deployed().then(function(deployed){deployed.allowance.call(web3.eth.accounts[0], TokenController.address).then(function(hash){console.log(hash)} )} );

//to send ether directly to the ICO contract : sending 60**18 i.e. 60 ethers
Token.deployed().then(function(deployed){deployed.sendTransaction({ from: web3.eth.accounts[1], value: web3.fromWei('10000000000000000000', 'ether')}).then(function(data){console.log(data)} ) } );
//temporary
Token.deployed().then(function(deployed){deployed.sendTransaction({ from: web3.eth.accounts[1], value: '10500000000000000000'}).then(function(data){console.log(data)} ) } );
//==================================================================================================

//================================================ sale related functions ==========================
//increasing allowed approval
Token.deployed().then(function(deployed){deployed.increaseApproval(ICO.address, '937500000').then(function(data){console.log(data)} ) } )
//decrease approval
Token.deployed().then(function(deployed){deployed.decreaseApproval(ICO.address, '100000').then(function(data){console.log(data)} ) } )
//===================================================================================================



Token.deployed().then(function(deployed){deployed.transfer.sendTransaction( web3.eth.accounts[1], '10500000000000000000').then(function(data){console.log(data)} ) } );
