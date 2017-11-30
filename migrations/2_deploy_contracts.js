var Token = artifacts.require("Token");
var TokenController = artifacts.require("TokenController");


module.exports = function(deployer) {
     
  deployer.deploy(Token); 
  deployer.deploy(TokenController); 
     
};
