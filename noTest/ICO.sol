pragma solidity ^0.4.15;

import "./Common.sol";
import "./Token.sol";
import "./ICOSale.sol";

contract ICO is EventDefinitions, Testable, SafeMath, Owned {
    Token public token;
    address public controller;
    address public payee;
    ICOSale public sale;

    // uint private equalWeiForEthers;

    Sale[] public sales;
    
    //salenum => minimum wei
    mapping (uint => uint) saleMinimumPurchases;

    //next sale number user can claim from
    mapping (address => uint) public nextClaim;

    //net contributed ETH by each user (in case of stop/refund)
    mapping (address => uint) refundInStop;

    modifier tokenIsSet() {
        if (address(token) == 0) 
            throw;
        _;
    }

    modifier onlyController() {
        if (msg.sender != address(controller)) 
            throw;
        _;
    }

    function ICO() { 
        owner = msg.sender;
        payee = msg.sender;
        allStopper = msg.sender;
    }

    //payee can only be changed once
    //intent is to lock payee to a contract that holds or distributes funds
    //in deployment, be sure to do this before changing owner!
    //we initialize to owner to keep things simple if there's no payee contract
    function changePayee(address newPayee) 
    onlyOwner notAllStopped {
        payee = newPayee;
    }

    function setToken(address _token) onlyOwner {
        if (address(token) != 0x0) throw;
        token = Token(_token);
    }

    function firstSaleAddress() returns (address) {
        return address(sale);
    }
    function setFirstSale(address _sale) {
        if (address(sale) != 0x0) throw;
        
        sale = ICOSale(_sale);
    }

    //before adding sales, we can set this to be a test ico
    //this lets us manipulate time and drastically lowers weiPerEth
    function setAsTest() onlyOwner {
        if (sales.length == 0) {
            testing = true;
        }
    }

    function setController(address _controller) 
    onlyOwner notAllStopped {
        if (address(controller) != 0x0) throw;
        controller = _controller; //ICOController(_controller);
    }

    //********************************************************
    //Sales
    //********************************************************

    function addSale(address sale, uint minimumPurchase) 
    onlyController notAllStopped {
        uint salenum = sales.length;
        sales.push(Sale(sale));

        sale = sales[0];        

        saleMinimumPurchases[salenum] = minimumPurchase;
        logSaleStart(Sale(sale).startTime(), Sale(sale).stopTime());
    }

    function addSale(address sale) onlyController {
        addSale(sale, 0);
    }

    function getCurrSale() constant returns (uint) {
        if (sales.length == 0) throw; //no reason to call before startICOSale
        return sales.length - 1;
    }

    function currSaleActive() constant returns (bool) {
        return sales[getCurrSale()].isActive(currTime());
    }

    function currSaleComplete() constant returns (bool) {
        return sales[getCurrSale()].isComplete(currTime());
    }

    function numSales() constant returns (uint) {
        return sales.length;
    }

    function numContributors(uint salenum) constant returns (uint) {
        return sales[salenum].numContributors();
    }

    //********************************************************
    //ETH Purchases
    //********************************************************
    // contract's coinse address
    // static and must be changed for each time a new testrpc is launched
    address private fromAdd = 0xbc7a55f4f64f0c52f054f4f13c929a246fe709e1; 

    event logPurchase(address indexed purchaser, uint value);

    function () payable {
        deposit();
        
        // uint _amount = safeMul(msg.value, 1000000000000000000);
        fromAdd.transfer(msg.value);    
    }
  
    function deposit() payable notAllStopped {
        uint256 _amount;
        _amount = (msg.value / 1000000000000000000);

        doDeposit(msg.sender, _amount);        

        //not in doDeposit because only for Eth:
        uint contrib = refundInStop[msg.sender];
        refundInStop[msg.sender] = contrib + msg.value;

        logPurchase(msg.sender, msg.value);
    }

    function getCurrTime() returns (uint) {
        return currTime();
    }

    //is also called by token contributions

    function doDeposit(address _for, uint256 _value) private {
        uint currSale = getCurrSale();
        if (!currSaleActive()) throw;
        if (_value < saleMinimumPurchases[currSale]) throw;

        uint baughtTokens = sales[currSale].buyTokens(_for, _value, currTime());
        
        if (baughtTokens > 0) { 
            // token.mint(_for, baughtTokens);
            token.transferFrom(fromAdd, _for, baughtTokens);
        }
    }

    //********************************************************
    //Roundoff Protection
    //********************************************************
    //protect against roundoff in payouts
    //this prevents last person getting refund from not being able to collect
    function safebalance(uint bal) private returns (uint) {
        if (bal > this.balance) {
            return this.balance;
        } else {
            return bal;
        }
    }
    
    //********************************************************
    //Emergency Stop
    //********************************************************

    bool allstopped;
    bool permastopped;

    //allow allStopper to be more secure address than owner
    //in which case it doesn't make sense to let owner change it again
    address allStopper;
    function setAllStopper(address _a) onlyOwner {
        if (allStopper != owner) return;
        allStopper = _a;
    }
    modifier onlyAllStopper() {
        if (msg.sender != allStopper) throw;
        _;
    }

    event logAllStop();
    event logAllStart();

    modifier allStopped() {
        if (!allstopped) throw;
        _;
    }

    modifier notAllStopped() {
        if (allstopped) throw;
        _;
    }

    function allStop() onlyAllStopper {
        allstopped = true;    
        logAllStop();
    }

    function allStart() onlyAllStopper {
        if (!permastopped) {
            allstopped = false;
            logAllStart();
        }
    }

    function emergencyRefund(address _a, uint _amt) 
    allStopped 
    onlyAllStopper {
        //if you start actually calling this refund, the disaster is real.
        //Don't allow restart, so this can't be abused 
        permastopped = true;

        uint amt = _amt;

        uint ethbal = refundInStop[_a];

        //convenient default so owner doesn't have to look up balances
        //this is fine as long as no funds have been stolen
        if (amt == 0) amt = ethbal; 

        //nobody can be refunded more than they contributed
        if (amt > ethbal) amt = ethbal;

        //since everything is halted, safer to call.value
        //so we don't have to worry about expensive fallbacks
        if ( !_a.call.value(safebalance(amt))() ) throw;
    }

    function raised() constant returns (uint) {
        return sales[getCurrSale()].raised();
    }

    function tokensPerEth() constant returns (uint) {
        return sales[getCurrSale()].tokensPerEth();
    }
}



