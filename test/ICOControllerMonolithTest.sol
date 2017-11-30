pragma solidity >=0.4.4;

import 'truffle/Assert.sol'; 
import 'truffle/DeployedAddresses.sol'; 
import '../contracts/ICO.sol';
import '../contracts/FirstSale.sol';
import "../contracts/Auction.sol";
import '../contracts/ICOControllerMonolith.sol';

contract Person {
    ICO ico;
    function Person(address _ico) {
        ico = ICO(_ico);
    }

    function deposit() payable {
        ico.deposit.value(msg.value)();
    }

    function claim() {
        ico.claim();
    }

    function () payable {
    }
}

contract ICOControllerMonolithTest is EventDefinitions, Constants {
    ICO ico;
    ICOControllerMonolith con;
    Person p1;
    Person advisor;
    Token token;
    uint weiPerEth = 200;
    
    function testSetUp() {
        con = ICOControllerMonolith(DeployedAddresses.ICOControllerMonolith());
        ico = ICO(DeployedAddresses.ICO());
        token = Token(DeployedAddresses.Token());

        p1 = new Person(address(ico));
        advisor = new Person(address(ico));

        con.setICO(address(ico));
        ico.setAsTest();
        ico.setController(con);
        token.setICO(address(ico));
        token.setController(address(con));
        ico.setToken(token);
        con.setFirstSaleLauncher(new FirstSaleLauncher());
        con.setAuctionLauncher(new AuctionLauncher());
        con.setAdvisor(address(advisor));

        ico.setFakeTime(1);
        weiPerEth = ico.weiPerEth();

        Assert.equal(con.setupComplete(), true, "setup is complete");
    }
 
}


