var ICOControllerMonolith = artifacts.require("./ICOControllerMonolith.sol");
var ICO = artifacts.require("./ICO.sol");

contract('ICOControllerMonolith', function(accounts) {
  it("1. Test for setting ICO", function() {
    return ICOControllerMonolith.deployed().then(function(instance) {
      instance.setICO.sendTransaction(ICO.address).then(
        function(data){
          console.log("controller transaction hash: "+ data);
        }
      );
      return instance.ico.call();
    }).then(function(address) {
      assert.equal(ICO.address, address, "ICO set");
    });
  });
  it("2. current sale", function() {
    return ICO.deployed().then(function(instance) {
      instance.setController.sendTransaction(ICOControllerMonolith.address).then(
        function(data){
          console.log("ico transaction hash: "+ data);
        }
      );

      return instance.getCurrSale.call();
    }).then(function(currSale) {
      assert.equal(currSale, 0, "sale is none");
    });
  });
});
