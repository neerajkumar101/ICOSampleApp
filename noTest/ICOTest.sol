pragma solidity >=0.4.4;

import 'truffle/Assert.sol'; 
import '../contracts/Common.sol';
import '../contracts/ICO.sol';
import '../contracts/FirstSale.sol';

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

    function claimableTokens() returns (uint) {
        return ico.claimableTokens();
    }

    function claimableRefund() returns (uint) {
        return ico.claimableRefund();
    }

    function () payable { }

    function acceptOwnership() {
        ico.acceptOwnership();
    }

}

contract Attacker {
    ICO ico;
    bool done = false;
    function Attacker(address _ico) {
        ico = ICO(_ico);
    }

    function deposit() payable {
        ico.deposit.value(msg.value)();
    }

    function claim() {
        ico.claim();
    }

    function () payable {
        bool wasdone = done;
        done = true;
        if (!wasdone) ico.claim();
    }
}

//for testing purposes
//this sale refunds half your money, and buys tokens with the rest
//and mints only upon calling claim()
contract SampleSale is Sale {
    uint public startTime;
    uint public stopTime;
    uint public target;
    uint public raised;
    uint public collected;
    uint public numContributors;
    uint price = 100;
    mapping(address => uint) public balances;

    function SampleSale(uint _time) {
        startTime = _time;
        stopTime = startTime + 10 days;
    }
    function buyTokens(address _a, uint _eth, uint _time) returns (uint) {
        if (balances[_a] == 0) {
            numContributors += 1;
        }
        balances[_a] += _eth;
        raised += _eth / 2;
        return 0;
    }
    function getTokens(address _a) constant returns (uint) {
        return price * (balances[_a]) / 2;
    } 
    function getRefund(address _a) constant returns (uint) {
        return balances[_a] / 2;
    }
    function getSoldTokens() constant returns (uint) {
        return (raised / 2) * price;
    }
    function getOwnerEth() constant returns (uint) {
        return raised;
    }
    function isActive(uint time) constant returns (bool) {
        return (time >= startTime && time <= stopTime);
    }
    function isComplete(uint time) constant returns (bool) {
        return (time >= stopTime);
    }
    function tokensPerEth() constant returns (uint) {
        return 1;
    }    
}

//like SampleSale but mints immediately
contract SampleSaleFastMint is SampleSale {
    function SampleSaleFastMint(uint _time) SampleSale(_time) {}
    function buyTokens(address _a, uint _eth, uint _time) returns (uint) {
        if (balances[_a] == 0) {
            numContributors += 1;
        }
        balances[_a] += _eth;
        raised += _eth / 2;
        return (_eth / 2) * price;
    }
    function getTokens(address _a) constant returns (uint) {
        return 0;
    } 
}

contract TestController is Owned {
    ICO public ico;
    uint weiPerDollar = 20;
    function TestController() {
        owner = msg.sender;
    }

    function setICO(address _ico) {
        ico = ICO(_ico);
    }

    function startSampleSale() {
        address sale = address(new SampleSale(ico.currTime())); 
        ico.addSale(sale);
    }

    function startSampleSaleFastMint() {
        address sale = address(new SampleSaleFastMint(ico.currTime())); 
        ico.addSale(sale);
    }

    function startSampleSaleWithMinimum(uint _minimum) {
        address sale = address(new SampleSale(ico.currTime())); 
        ico.addSale(sale, _minimum);
    }
}

contract ICOTest is EventDefinitions {
    ICO ico;
    TestController con;
    Person p1;
    Person p2;
    Person p3;
    Token token;

    //for testing we say 10 weis makes an eth
    //because dapple only gives us 10 eths to work with
    //so let's say 1 ether = 10 dollars = 200 wei
    uint weiPerDollar = 20;
    uint weiPerEth = 200;

    function () payable {}

    function eth(uint eth) returns (uint) {
        return eth * weiPerEth;
    }
    function dollars(uint d) returns (uint) {
        return d * weiPerDollar;
    }
    
    function setUp() {
        con = new TestController();
        ico = new ICO();
        con.setICO(ico);
        ico.setController(con);
        ico.setAsTest();
        token = new Token();
        token.setICO(address(ico));
        token.setController(con);
        ico.setToken(token);

        ico.setFakeTime(1);
        weiPerEth = ico.weiPerEth();
        p1 = new Person(address(ico));
        p2 = new Person(address(ico));
        p3 = new Person(address(ico));
    }

    function testFirstSaleNum() {
        con.startSampleSale();
        ico.setFakeTime(3 days + 2);
        Assert.equal(ico.getCurrSale(), 0, "first sale not set");
        Assert.equal(ico.nextClaim(address(p1)), 0, "first claim");
    }

    function testThrowsMinimumPurchase() {
        con.startSampleSaleWithMinimum(10);
        Sale sale = ico.sales(0);
        ico.setFakeTime(3 days + 2);
        p1.deposit.value(5)();
    }

    function testAboveMinimumPurchase() {
        con.startSampleSaleWithMinimum(10);
        Sale sale = ico.sales(0);
        ico.setFakeTime(3 days + 2);
        p1.deposit.value(20)();
    }

    function testBuy() {
        // expectEventsExact(ico); //i did it
    
        uint weis = 1000;

        con.startSampleSale();
        Sale sale = ico.sales(0);
        logSaleStart(sale.startTime(), sale.stopTime());

        ico.setFakeTime(3 days + 2);

        Assert.equal(ico.currSaleActive(), true, "active");
        Assert.equal(ico.currSaleComplete(), false, "complete");

        p1.deposit.value(weis)();
        logPurchase(address(p1), weis);
        Assert.equal(p1.claimableRefund(), 0, "incomplete refund");
        Assert.equal(p1.claimableTokens(), 0, "incomplete tokens");

        ico.addDays(20);
        Assert.equal(ico.currSaleActive(), false, "2 active");
        Assert.equal(ico.currSaleComplete(), true, "2 complete");
        Assert.equal(p1.claimableRefund(), weis / 2, "complete refund");
        Assert.equal(p1.claimableTokens(), 100 * weis / 2, "complete tokens");
    }

    function testClaim() {
        uint weis = 1000;

        con.startSampleSale();
        ico.setFakeTime(3 days + 2);

        Assert.equal(ico.currSaleActive(), true, "active");
        Assert.equal(ico.currSaleComplete(), false, "complete");

        p1.deposit.value(weis)();
        logPurchase(address(p1), weis);
        Assert.equal(p1.claimableRefund(), 0, "incomplete refund");
        Assert.equal(p1.claimableTokens(), 0, "incomplete tokens");

        ico.addDays(20);
        Assert.equal(ico.currSaleActive(), false, "2 active");
        Assert.equal(ico.currSaleComplete(), true, "2 complete");
        Assert.equal(p1.claimableRefund(), weis / 2, "complete refund");
        Assert.equal(p1.claimableTokens(), 100 * weis / 2, "complete tokens");

        p1.claim();
        Assert.equal(ico.nextClaim(address(p1)), 1, "next claim");
        Assert.equal(p1.balance, weis / 2, "p1 balance");
        Assert.equal(p1.claimableRefund(), 0, "p1 refund after claim");
        Assert.equal(p1.claimableTokens(), 0, "p1 tokens after claim");
    }

    function testClaimFastMint() {
        uint weis = 1000;

        con.startSampleSaleFastMint();
        ico.setFakeTime(3 days + 2);

        Assert.equal(ico.currSaleActive(), true, "active");
        Assert.equal(ico.currSaleComplete(), false, "complete");

        p1.deposit.value(weis)();
        logPurchase(address(p1), weis);
        Assert.equal(token.balanceOf(address(p1)), 100 * weis / 2, "fast mint");
        Assert.equal(p1.claimableRefund(), 0, "incomplete refund");
        Assert.equal(p1.claimableTokens(), 0, "incomplete tokens");

        ico.addDays(20);
        Assert.equal(ico.currSaleActive(), false, "2 active");
        Assert.equal(ico.currSaleComplete(), true, "2 complete");
        Assert.equal(p1.claimableRefund(), weis / 2, "complete refund");
        Assert.equal(p1.claimableTokens(), 0, "complete tokens");

        p1.claim();
        Assert.equal(ico.nextClaim(address(p1)), 1, "next claim");
        Assert.equal(p1.balance, weis / 2, "p1 balance");
        Assert.equal(p1.claimableRefund(), 0, "p1 refund after claim");
        Assert.equal(p1.claimableTokens(), 0, "p1 tokens after claim");
    }

    function testClaimFor() {
        uint weis = 1000;

        con.startSampleSale();
        ico.setFakeTime(4 days);
        p1.deposit.value(weis)();

        ico.addDays(20);
        Assert.equal(p1.claimableRefund(), weis / 2, "complete refund");
        Assert.equal(p1.claimableTokens(), 100 * weis / 2, "complete tokens");

        ico.addDays(400);
        ico.claimFor(address(p1), address(p2));

        Assert.equal(p2.balance, weis / 2, "recipient balance");
        Assert.equal(token.balanceOf(address(p2)), 100 * weis / 2, "recip tokens");

        Assert.equal(p2.claimableTokens(), 0, "recip claimable tokens");
        Assert.equal(p2.claimableRefund(), 0, "recip claimable refund");
        Assert.equal(p1.claimableTokens(), 0, "p1 claimable tokens 2");
        Assert.equal(p1.claimableRefund(), 0, "p1 claimable refund 2");
    }

    function testClaimForTooSoon() {
        uint weis = 1000;

        con.startSampleSale();
        ico.setFakeTime(4 days);
        p1.deposit.value(weis)();

        ico.addDays(20);
        Assert.equal(p1.claimableRefund(), weis / 2, "complete refund");
        Assert.equal(p1.claimableTokens(), 100 * weis / 2, "complete tokens");

        ico.claimFor(address(p1), address(p2));

        Assert.equal(p2.balance, 0, "recipient balance");
        Assert.equal(token.balanceOf(address(p2)), 0, "recip tokens");

        Assert.equal(p1.claimableRefund(), weis / 2, "p1 claimable refund 2");
        Assert.equal(p1.claimableTokens(), 100 * weis / 2, "p1 claimable tokens 2");
    }

    function testDoubleClaim() {
        //two people deposit max so each should get half back
        //one tries to do it twice and take it all
        uint weis = 1000;

        con.startSampleSale();
        ico.setFakeTime(4 days);

        p1.deposit.value(weis)();
        p2.deposit.value(weis)();

        ico.addDays(20);
        p1.claim();
        p1.claim();

        Assert.equal(p1.balance, 500, "p1 balance");
        Assert.equal(token.balanceOf(address(p1)), 50000, "p1 tokens");

        p2.claim();
        Assert.equal(p2.balance, 500, "p2 balance");
        Assert.equal(token.balanceOf(address(p2)), 50000, "p2 tokens");
    }

    function testThrowReentrantAttack () {
        //two people deposit max so each should get half back
        //one tries to do it twice via reentrance 
        uint weis = 1000;

        con.startSampleSale();
        ico.setFakeTime(4 days);

        p1.deposit.value(weis)();

        Attacker a2 = new Attacker(ico);
        a2.deposit.value(weis)();

        ico.addDays(20);
        a2.claim();
        p1.claim();

        Assert.equal(p1.balance, 500, "p1 balance");
        Assert.equal(token.balanceOf(address(p1)), 100 * weis / 2, "p1 tokens");

        a2.claim();
        Assert.equal(a2.balance, 500, "a2 balance");
        Assert.equal(token.balanceOf(address(a2)), 100 * weis / 2, "a2 tokens");
    }

    function testMulticlaim() {
        uint weis = 1000;

        //DEPOSIT IN FIRST SALE

        con.startSampleSale();
        ico.setFakeTime(4 days);

        p1.deposit.value(weis)();

        ico.addDays(20);
        Assert.equal(ico.currSaleActive(), false, "0 active");
        Assert.equal(ico.currSaleComplete(), true, "0 complete");

        //DEPOSIT IN SECOND SALE
        con.startSampleSale();
        ico.addDays(4);
        Assert.equal(ico.currSaleActive(), true, "1 active");
        Assert.equal(ico.currSaleComplete(), false, "1 complete");
        
        p1.deposit.value(weis)();

        ico.addDays(20);
        Assert.equal(ico.currSaleActive(), false, "1 active b");
        Assert.equal(ico.currSaleComplete(), true, "1 complete b");

        //DEPOSIT IN THIRD SALE
        con.startSampleSale();
        ico.addDays(4);
        Assert.equal(ico.currSaleActive(), true, "2 active");
        Assert.equal(ico.currSaleComplete(), false, "2 complete");
        
        p1.deposit.value(weis)();

        //DO A CLAIM WHILE THIRD SALE RUNNING
        //so this is a claim on two sales

        p1.claim();
        //at this point we should have tokens and refund from first two sales
        Assert.equal(p1.balance, 2 * (weis / 2), "balance2");
        Assert.equal(token.balanceOf(address(p1)), 2 * (100 * weis / 2), "tokens2");

        //END THIRD SALE AND CLAIM

        ico.addDays(20);
        p1.claim();

        //now should have tokens and refund frmo all three sales
        Assert.equal(p1.balance, 3 * (weis / 2), "balance3");
        Assert.equal(token.balanceOf(address(p1)), 3 * (100 * weis / 2), "tokens3");
    }

    function testClaimWithActiveSale() {
        uint weis = 1000;

        con.startSampleSale();
        ico.setFakeTime(4 days);

        p1.deposit.value(weis)();
        p1.claim();
        Assert.equal(address(p1).balance, 0, "eth balance");
        Assert.equal(token.balanceOf(address(p1)), 0, "token balance");
    }

    function testOwnerWithdraw() {
        uint weis = 1000;
        con.startSampleSale();
        ico.setFakeTime(3 days + 2);
        p1.deposit.value(weis)();
        ico.addDays(20);
        Assert.equal(address(ico).balance, 1000, "pre-withdraw");
        uint prewithdraw = this.balance;
        ico.claimOwnerEth(0);
        Assert.equal(address(ico).balance, 500, "withdraw");
        Assert.equal(this.balance, prewithdraw + 500, "post-withdraw");
    }

    function testTopup() {
        uint weis = 1000;
        con.startSampleSale();
        ico.setFakeTime(3 days + 2);
        p1.deposit.value(weis)();
        Assert.equal(ico.balance, weis, "a");
        Assert.equal(ico.topUpAmount(), 0, "b");
        
        ico.topUp.value(10)();
        Assert.equal(ico.balance, weis + 10, "c");
        Assert.equal(ico.topUpAmount(), 10, "d");

        ico.withdrawTopUp();
        Assert.equal(ico.balance, weis, "e");
        Assert.equal(ico.topUpAmount(), 0, "f");
        
        ico.withdrawTopUp();
        Assert.equal(ico.balance, weis, "g");
    }

    function testBuyerCount() {
        con.startSampleSale();
        Sale sale = ico.sales(0);
        ico.setFakeTime(3 days + 2);
        p1.deposit.value(1)();
        p1.deposit.value(2)();
        p3.deposit.value(2)();

        Assert.equal(ico.numContributors(0), 2, "count");
    }


    function testStopAndRefund() {
        uint weis = 1000;

        con.startSampleSale();
        ico.setFakeTime(3 days + 2);

        p1.deposit.value(weis)();

        ico.allStop();
        ico.allStart();

        p1.deposit.value(weis)();

        ico.allStop();

        ico.emergencyRefund(address(p1), weis * 2);
        Assert.equal(address(p1).balance, weis * 2, "emergency refund");
    }

    function testThrowStop() {
        uint weis = 1000;
        con.startSampleSale();
        ico.setFakeTime(3 days + 2);
        ico.allStop();
        p1.deposit.value(weis)();
    }

    function testThrowEmergencyRefundWithoutStop() {
        uint weis = 1000;
        con.startSampleSale();
        ico.setFakeTime(3 days + 2);
        p1.deposit.value(weis)();
        ico.emergencyRefund(address(p1), weis);
    }

    function testSetPayee() {
        ico.changePayee(0x0);
        Assert.equal(ico.payee(), 0x0, "payee");
    }
        
    /*  Fix this test */
    function testPurchaseByToken() {
        uint weis = 1000;

        con.startSampleSaleFastMint();
        ico.setFakeTime(3 days + 2);

        Assert.equal(ico.currSaleActive(), true, "active");
        Assert.equal(ico.currSaleComplete(), false, "complete");

        Assert.equal(ico.tokensPerEth(), 1, "tokens per eth");
        Assert.equal(weiPerEth, 200, "wei per eth");

        address tok = address(new Token());
        ico.depositTokens(address(p1), 0x1, weis, 100, bytes32(0x123));

        Assert.equal(token.balanceOf(address(p1)), 1000 / weiPerEth, "fast mint");
        Assert.equal(p1.claimableRefund(), 0, "incomplete refund");
        Assert.equal(p1.claimableTokens(), 0, "incomplete tokens");
    }

    function testThrowsPurchaseByToken() {
        uint weis = 1000;

        con.startSampleSaleFastMint();
        ico.setFakeTime(3 days + 2);

        Assert.equal(ico.currSaleActive(), true, "active");
        Assert.equal(ico.currSaleComplete(), false, "complete");

        ico.depositTokens(address(p1), 0x1, weis, 100, bytes32(0x123));
        ico.depositTokens(address(p1), 0x1, weis, 100, bytes32(0x123));
    }

    function testChangeOwner() {
        ico.changeOwner(address(p1));
        p1.acceptOwnership();
        Assert.equal(ico.owner(), address(p1), "owner");
    }

}

