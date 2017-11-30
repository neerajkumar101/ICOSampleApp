pragma solidity >=0.4.15;

//just a trick to avoid error in testing
contract Common {
    function Common() public {
        
    }
}
/*
contract EventDefinitions {
    event logSaleStart(uint startTime, uint stopTime);
    event logPurchase(address indexed purchaser, uint eth);
    event logClaim(address indexed purchaser, uint refund, uint tokens);

    //Token standard events
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
} 

contract Testable {
    uint fakeTime;
    bool public testing;
    modifier onlyTesting() {
        if (!testing) revert();
        _;
    }
    function setFakeTime(uint t) public onlyTesting {
        fakeTime = t;
    }
    function addMinutes(uint m) public onlyTesting {
        fakeTime = fakeTime + (m * 1 minutes);
    }
    function addDays(uint d) public onlyTesting {
        fakeTime = fakeTime + (d * 1 days);
    }
    function currTime() constant public returns (uint) {
        if (testing) {
            return fakeTime;
        } else {
            return block.timestamp;
        }
    }
    function weiPerEth() constant public returns (uint) {
        if (testing) {
            return 200;
        } else {
            return 10**18;
        }
    }
}

contract Sale {
    uint public startTime;
    uint public stopTime;
    uint public target;
    uint public raised;
    uint public collected;
    uint public numContributors;
    mapping(address => uint) public balances;

    function buyTokens(address _a, uint _eth, uint _time) public returns (uint); 
    function getTokens(address holder) constant public returns (uint); 
    function getRefund(address holder) constant public returns (uint); 
    function getSoldTokens() constant public returns (uint); 
    function getOwnerEth() constant public returns (uint); 
    function tokensPerEth() constant public returns (uint);
    function isActive(uint time) constant public returns (bool); 
    function isComplete(uint time) constant public returns (bool); 
}
*/
contract Constants {
    uint DECIMALS = 0;
}

contract Owned {
    address public owner;
    
    modifier onlyOwner() {
        if (msg.sender != owner) 
            revert();        
        _;
    }

    address newOwner;

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }    
}

//from Zeppelin
contract SafeMath {
    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeSub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
    }

    function assert(bool assertion) internal {
        if (!assertion) 
            revert();
    }
}

