pragma solidity >=0.4.4;

import 'truffle/Assert.sol'; 
import "../contracts/Token.sol";
import "../contracts/Common.sol";

contract Person {
    Token token;
    function Person(address _token) {
        token = Token(_token);
    }
    function transfer(address to, uint value) returns (bool) {
        return token.transfer(to, value);
    }
    function approve(address spender, uint value) returns (bool) {
        return token.approve(spender, 100);
    }
    function transferFrom(address from, address to, uint value) 
    returns (bool) {
        return token.transferFrom(from, to, value);
    }
    function burn(uint value) returns (bool) {
        return token.burn(value);
    }
}

contract ICO {
    Token token;
    function ICO(address _token) {
        token = Token(_token);
    }
    function mint(address a, uint value) {
        token.mint(a, value);
    }
}

contract TokenTest is EventDefinitions {
    Token token;
    ICO ico;
    ICO controller;
    Person p1;
    Person p2;
    Person p3;
    address a1;
    address a2;
    address a3;
    function setUp() {
        token = new Token();
        ico = new ICO(token);
        controller = new ICO(token);
        token.setICO(ico);
        token.setController(controller);
        p1 = new Person(token); 
        p2 = new Person(token); 
        p3 = new Person(token); 
        a1 = address(p1);
        a2 = address(p2);
        a3 = address(p3);
        ico.mint(address(p1), 1000);
        ico.mint(address(p2), 1000);
        ico.mint(address(p3), 1000);
    }

    function testSupply() {
        Assert.equal(token.totalSupply(), 3000, "total supply");
    }

    function testTransfer() {
        // expectEventsExact(token); // i did it
        Transfer(a1, a2, 200);
        p1.transfer(a2, 200);
        Assert.equal(token.balanceOf(a1), 800, "p1 balance");
        Assert.equal(token.balanceOf(a2), 1200, "p2 balance");
    }

    function testTransferAll() {
        // expectEventsExact(token); //i did it
        Transfer(a1, a2, 1000);
        Transfer(a2, a1, 2000);

        p1.transfer(a2, 1000);
        Assert.equal(token.balanceOf(a1), 0, "p1 balance");
        Assert.equal(token.balanceOf(a2), 2000, "p2 balance");
        p2.transfer(a1, 2000);
        Assert.equal(token.balanceOf(a1), 2000, "p1 balance 2");
        Assert.equal(token.balanceOf(a2), 0, "p2 balance 2");
    }

    function testTransferFrom() {
        // expectEventsExact(token);// i did it
        Approval(a1, a2, 100);
        Transfer(a1, a3, 50);

        p1.approve(a2, 100);
        Assert.equal(token.allowance(a1, a2), 100, "allowance");
        p2.transferFrom(a1, a3, 50);
        Assert.equal(token.balanceOf(a1), 950, "p1 balance");
        Assert.equal(token.balanceOf(a3), 1050, "p3 balance");
        Assert.equal(token.allowance(a1, a2), 50, "new allowance");
    }

    function testTransferFrom2() {
        // expectEventsExact(token); //i did it
        Transfer(a3, a1, 1000);
        Approval(a1, a2, 100);
        Transfer(a1, a3, 50);

        p3.transfer(a1, 1000);
        Assert.equal(token.balanceOf(a3), 0, "p1 balance");
        Assert.equal(token.balanceOf(a1), 2000, "p2 balance");

        p1.approve(a2, 100);
        Assert.equal(token.allowance(a1, a2), 100, "allowance");
        p2.transferFrom(a1, a3, 50);
        Assert.equal(token.balanceOf(a1), 1950, "p1 balance");
        Assert.equal(token.balanceOf(a3), 50, "p3 balance");
        Assert.equal(token.allowance(a1, a2), 50, "new allowance");
    }

    /* older tests when threw instead of returning false
    function testThrowTransfer() {
        expectEventsExact(token);
        p1.transfer(address(p2), 1001);
    }

    function testThrowTransferFrom() {
        expectEventsExact(token);
        Approval(a1, a2, 100);

        p1.approve(a2, 100);
        Assert.equal(token.allowance(a1, a2), 100, "allowance");
        p2.transferFrom(a1, a3, 200);
    }
    
    function testThrowTransferFrom2() {
        Assert.equal(token.allowance(a1, a2), 0, "allowance");
        p2.transferFrom(a1, a3, 200);
    }
    */

    function testBadTransfer() {
        uint initialbal = token.balanceOf(a1);
        bool result = p1.transfer(a2, 1001);
        Assert.equal(result, false, "result");
        Assert.equal(initialbal, token.balanceOf(a1), "balance");
    }

    function testBadTransferFrom() {
        // expectEventsExact(token); //i did it
        Approval(a1, a2, 100);

        uint initialbal = token.balanceOf(a1);
        p1.approve(a2, 100);
        Assert.equal(token.allowance(a1, a2), 100, "allowance");
        bool result = p2.transferFrom(a1, a3, 200);
        Assert.equal(result, false, "result");
        Assert.equal(initialbal, token.balanceOf(a1), "balance");
    }
    
    function testBadTransferFrom2() {
        uint initialbal = token.balanceOf(a1);
        Assert.equal(token.allowance(a1, a2), 0, "allowance");
        bool result = p2.transferFrom(a1, a3, 200);
        Assert.equal(result, false, "result");
        Assert.equal(initialbal, token.balanceOf(a1), "balance");
    }

    //this function initially passed without throw
    //but actually we want to throw for now
    //we don't want people to burn with the current placeholder tokenHolder
    //so, changed the placeholder so it returns false causing throw
    //and changed this test to pass if it throws
    function testThrowsBurn() {
        address th = address(new TokenHolder());
        token.setTokenHolder(th);
        uint firstbal = token.balanceOf(address(p1));
        uint firstsupply = token.totalSupply();
        bool result = p1.burn(3);
        Assert.equal(token.balanceOf(address(p1)), firstbal - 3, "burned bal");
        Assert.equal(token.totalSupply(), firstsupply - 3, "burned supply");
        Assert.equal(result, true, "burn result");
    }

    function testThrowsSetTokenHolder() {
        address th = address(new TokenHolder());
        token.setTokenHolder(th);
        token.lockTokenHolder();
        token.setTokenHolder(0x1);
    }

}
