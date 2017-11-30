# NodeJS Backend of ICO Smart Contract : 

# What is Ethereum :
 Ethereum is a blockchain technology based distributed computing platform which is open-source and public, It gives us a decentralized Turing-complete virtual machine and EVM(Ethereum Virtual Machine) which executes the scripts via an international network of public nodes. Ethereum provides a cryptocurrency which is called as "Ether", Ether can be transferred between accounts, there are resources which is allocated via 'internal transaction pricing mechanism' by mitigating spam


# What is Smart Contract : 
 "Smart contracts is a conflict-free way which provides a way to exchange-money, shares & properties or anything of value in a transparent manner while avoiding the services of a third person."


# What is Ether ?

The token of the Ethereum blockchain is called 'ether'. It is listed under cryptocurrency exchanges. It provies a medium to pay for transaction fees on the Ethereum network.


  ## Requirments:

1) OS(ubuntu) & nodejs should installed with version 6.9.11 or bigger
2) Truffle should be installed
3) testrpc should be installed

 

 ## Project Setup and Installations:

1. For install node (if not install before): https://nodejs.org/en/download/
2. cd
3. dpkg -i path(full path of node js download file) .
4. sudo apt-get update 
5. node -v
6. npm -v 
7. npm install -g truffle  // truffle install
8. sudo apt-get update    // update the ubuntu packages
9. sudo apt-get install git // install git if not installed before
10. git clone "https://github.com/oodlestechnologies/ScriptDrop.git" // Take the clone pf Project
11. cd ScriptDrop
12. cd ICO and SmartContract/Node Js Api Part/Node ICO Backend/API
13. sudo NODE_ENV=development node server.js
14. open new Tab by pressing (Ctrl + Shift + T) .
15. cd ../../../ICO Part

16. Note : - (Go to ICO.sol => line no 126 and replace  etheruim coinbase address with testrpc available account first address).

17. truffle deploy
18. truffle consol8e

## Settings:

 1. We need to set few deployed smart contract address to userService.js 
 2.  These smart contract address will be returning after truffle deploy commend runs properly)
 3.  Copy and Paste all Json files that will be available on path 'ScriptDrop/ICO and SmartContract/ICO Part/build/contracts' to path 'ScriptDrop/ICO and SmartContract/Node Js Api Part/Node ICO Backend/API/application/controller-service-layer/contractsJson'
 4.  All the installation process and settting process done then Use ICO deploy Api
 5. Done

## API

ICO deploy Setup API :- 

## localhost:3003/api/v1/userapi/deploy
## localhost:3003/api/v1/userapi/startFirstICOSale 
## localhost:3003/api/v1/userapi/getSalesCount 



Note :-  if you have any other domain name that will be attached be our nodejs project 
 then replace localhost:3003 to your domain name

Note :- This Api is use for setup and deploy All ICO which we have on block chain truffle and web3.js . we are actually deploying ICO on block Chain using setting setICO ,setAsTest,
setController , setFirstSaleLauncher , setAuctionLauncher , setAdvisor , setFakeTime on smart contracts. 

Note:- startFirstICOSale and getSalesCount have issue 


# Note: -  Direct deployment using Truffle 
  
  if you are using truffle directly then you should go on path 'ICO Part/app/app.js'.
  app.js have all the functions of ICO smart contrcat that will be connect with block chain 
  Technologies.

 ## license

[ISC](https://github.com/)
