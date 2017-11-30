pragma solidity >=0.4.4;

import 'truffle/Assert.sol'; 
import '../contracts/Common.sol';
import '../contracts/Auction.sol';

contract AuctionTest is EventDefinitions {
    Auction sale;
    address a1;
    address a2;
    address a3;
    address a4;
    uint startTime = 1;

    function setUp() {
        a1 = address(1);
        a2 = address(2);
        a3 = address(3);
        a4 = address(4);
    }

    function testExactSale() {
        //expectEventsExact(sale);

        uint tokens = 1000;
        uint target = 100 ether;
        sale = new Auction(address(this), tokens, target, 0, 1, 3, 0);

        sale.buyTokens(a1, 20 ether, startTime + 1);
        sale.buyTokens(a2, 30 ether, startTime + 1);
        sale.buyTokens(a3, 50 ether, startTime + 1);
        Assert.equal(sale.raised(), 100 ether, "raised");

        Assert.equal(sale.getTokens(a1), 200, "a1 tokens");
        Assert.equal(sale.getTokens(a2), 300, "a2 tokens");
        Assert.equal(sale.getTokens(a3), 500, "a3 tokens");
        Assert.equal(sale.getSoldTokens(), 1000, "sold tokens");
        
        Assert.equal(sale.getRefund(a1), 0, "a1 refund");
        Assert.equal(sale.getRefund(a2), 0, "a2 refund");
        Assert.equal(sale.getRefund(a3), 0, "a3 refund");

        Assert.equal(sale.getOwnerEth(), 100 ether, "owner eth");
        Assert.equal(sale.balances(a1), 20 ether, "a1 ether bal");

        Assert.equal(sale.balances(a4), 0, "a4 ether bal");
        Assert.equal(sale.getRefund(a4), 0, "a4 refund");
        Assert.equal(sale.getTokens(a4), 0, "a4 tokens");
        //logPurchase();
    }

    function testExactSaleSmallRefund() {
        //expectEventsExact(sale);

        uint tokens = 1000;
        uint target = 100 ether;
        sale = new Auction(address(this), tokens, target, 0, 1, 3, 0);

        sale.buyTokens(a1, 100 ether + 1, startTime + 1);
        Assert.equal(sale.raised(), 100 ether + 1, "raised");

        Assert.equal(sale.getTokens(a1), 1000, "a1 tokens");
        Assert.equal(sale.getSoldTokens(), 1000, "sold tokens");
        
        Assert.equal(sale.getRefund(a1), 1, "a1 refund");

        Assert.equal(sale.getOwnerEth(), 100 ether, "owner eth");
        Assert.equal(sale.balances(a1), 100 ether + 1, "a1 ether bal");
        //logPurchase(); 
    }

    function testExactDoubleFraction() {
        //expectEventsExact(sale);

        uint tokens = 1000;
        uint target = 100 ether;
        sale = new Auction(address(this), tokens, target, 0, 1, 3, 0);

        uint halfeth = 1 ether / 2;

        sale.buyTokens(a1, 50 ether + halfeth, startTime + 1);
        sale.buyTokens(a3, 50 ether + halfeth, startTime + 1);
        Assert.equal(sale.raised(), 101 ether, "raised");

        //effective deposit = deposit * target/raised
        //effective deposit = 50 * 100 / 101 = 49.5
        //10 tokens per eth so 49.5 eth => 495 tokens

        Assert.equal(sale.getTokens(a1), 495, "a1 tokens");
        Assert.equal(sale.getTokens(a3), 495, "a3 tokens");
        Assert.equal(sale.getSoldTokens(), 990, "sold tokens");
        
        Assert.equal(sale.getRefund(a1), halfeth, "a1 refund");
        Assert.equal(sale.getRefund(a3), halfeth, "a3 refund");

        Assert.equal(sale.getOwnerEth(), 100 ether, "owner eth");
        Assert.equal(sale.balances(a1), 50 ether + halfeth, "a1 ether bal");
        Assert.equal(sale.balances(a3), 50 ether + halfeth, "a3 ether bal");

        //logPurchase();
    }

    function testOverSale() {
        //expectEventsExact(sale);

        uint tokens = 1000;
        uint target = 100 ether;
        sale = new Auction(address(this), tokens, target, 0, 1, 3, 0);

        sale.buyTokens(a1, 40 ether, startTime + 1);
        sale.buyTokens(a2, 60 ether, startTime + 1);
        sale.buyTokens(a3, 100 ether, startTime + 1);
        Assert.equal(sale.raised(), 200 ether, "raised");
        Assert.equal(sale.getOwnerEth(), 100 ether, "owner eth");
        Assert.equal(sale.balances(a1), 40 ether, "a1 ether bal");

        uint raised = 200 ether;
        uint weiPerToken = raised / tokens;

        Assert.equal(sale.getTokens(a1), 100, "a1 tokens");
        Assert.equal(sale.getTokens(a2), 150, "a2 tokens");
        Assert.equal(sale.getTokens(a3), 250, "a3 tokens");
        Assert.equal(sale.getSoldTokens(), 500, "sold tokens");

        Assert.equal(sale.getRefund(a1), 20 ether, "a1 refund");
        Assert.equal(sale.getRefund(a2), 30 ether, "a2 refund");
        Assert.equal(sale.getRefund(a3), 50 ether, "a3 refund");

        //logPurchase();
    }

    function testSingleOverSale() {
        //expectEventsExact(sale);

        uint tokens = 1000;
        uint target = 100 ether;
        sale = new Auction(address(this), tokens, target, 0, 1, 3, 0);

        sale.buyTokens(a1, 200 ether, startTime + 1);
        Assert.equal(sale.raised(), 200 ether, "raised");
        Assert.equal(sale.getOwnerEth(), 100 ether, "owner eth");
        Assert.equal(sale.balances(a1), 200 ether, "a1 ether bal");

        uint raised = 200 ether;
        uint weiPerToken = raised / tokens;

        Assert.equal(sale.getTokens(a1), 500, "a1 tokens");
        Assert.equal(sale.getSoldTokens(), 500, "sold tokens");

        Assert.equal(sale.getRefund(a1), 100 ether, "a1 refund");

        //logPurchase();
    }

    function testUnderSale() {
        //expectEventsExact(sale);

        uint tokens = 1000;
        uint target = 100 ether;
        sale = new Auction(address(this), tokens, target, 0, 1, 3, 0);

        sale.buyTokens(a1, 10 ether, startTime + 1);
        sale.buyTokens(a2, 15 ether, startTime + 1);
        sale.buyTokens(a3, 25 ether, startTime + 1);
        Assert.equal(sale.raised(), 50 ether, "raised");
        Assert.equal(sale.getOwnerEth(), 50 ether, "owner eth");
        Assert.equal(sale.balances(a1), 10 ether, "a1 ether bal");

        uint raised = 50 ether;
        uint weiPerToken = raised / tokens;

        Assert.equal(sale.getTokens(a1), 200, "a1 tokens");
        Assert.equal(sale.getTokens(a2), 300, "a2 tokens");
        Assert.equal(sale.getTokens(a3), 500, "a3 tokens");
        Assert.equal(sale.getSoldTokens(), 1000, "sold tokens");

        Assert.equal(sale.getRefund(a1), 0, "a1 refund");
        Assert.equal(sale.getRefund(a2), 0, "a2 refund");
        Assert.equal(sale.getRefund(a3), 0, "a3 refund");

        //logPurchase();
    }

    function testZeroSale() {
        uint tokens = 1000;
        uint target = 100 ether;
        sale = new Auction(address(this), tokens, target, 0, 1, 3, 0);
        sale.buyTokens(a1, 0, startTime + 1);
        Assert.equal(sale.getSoldTokens(), 0, "sold tokens");
        Assert.equal(sale.getOwnerEth(), 0, "owner eth");
        Assert.equal(sale.getTokens(a1), 0, "a1 tokens");
        Assert.equal(sale.getRefund(a1), 0, "a1 refund");
    }

    function testActive() {
        sale = new Auction(address(this), 100, 1000, 0, 2, 3, 0);
        Assert.equal(sale.isActive(1 days), false, "1 day");
        Assert.equal(sale.isActive(2 days), true, "2 days");
        Assert.equal(sale.isActive(3 days), true, "3 days");
        Assert.equal(sale.isActive(5 days), true, "5 days");
        Assert.equal(sale.isActive(6 days), false, "6");
    }

    function testCompleted() {
        sale = new Auction(address(this), 100, 1000, 0, 1, 3, 0);
        Assert.equal(sale.isComplete(1 days), false, "1 day");
        Assert.equal(sale.isComplete(3 days), false, "3 days");
        Assert.equal(sale.isComplete(4 days), false, "4 days");
        Assert.equal(sale.isComplete(5 days), true, "5 days");
    }

    function testUnderMinimum() {
        uint tokens = 1000;
        uint target = 100 ether;
        uint min = 10 ether;
        sale = new Auction(address(this), tokens, target, min, 1, 3, 0);

        sale.buyTokens(a1, 5 ether, startTime + 1);
        Assert.equal(sale.raised(), 5 ether, "raised");

        Assert.equal(sale.getTokens(a1), 0, "a1 tokens");
        Assert.equal(sale.getSoldTokens(), 0, "sold tokens");
        
        Assert.equal(sale.getRefund(a1), 5 ether, "a1 refund");

        Assert.equal(sale.getOwnerEth(), 0 , "owner eth");
        Assert.equal(sale.balances(a1), 5 ether, "a1 ether bal");
    }
}



