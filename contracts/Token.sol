pragma solidity >=0.4.15;

import './Common.sol';

contract ERC20Interface {
    function getTotalSupply() public returns (uint totalSupply);
    function getTokenBalance(address _owner) public constant returns (uint balance);
    function mint(address _addr, uint _amount) public;
    function burn(uint _amount) public returns (bool result);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success);
    function allowance(address _owner, address _spender) public constant returns (uint remaining);
  
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event Mint(address owner, uint amount);
    event Burn(address burner, uint amount);    
 }

contract Token is ERC20Interface, SafeMath, Owned, Constants {
    uint public totalSupply;
    address ico;
    address controller;
    string public name;
    uint public decimals; 
    string public symbol;     

    //must set the address of the coinbase of contracts and benificiary account as both are same here
    address private tokenContractCoinbase = 0x0270a33e6ac28b8c1d444bb5eab3ad1d453e4d5f;
    
    function Token() public {     
        owner = msg.sender;
        // totalSupply = 100000000000000000000000;        
        // balanceOf[owner] = totalSupply;

        owner = msg.sender;
        name = "Custom Token";
        decimals = uint(DECIMALS);
        symbol = "CT";
    }

    function getTotalSupply() public returns (uint) {
        return totalSupply;
    }

    function getTokenBalance(address _a) public constant returns (uint) {
        return balanceOf[_a];
    }

    //only called from contracts so don't need msg.data.length check
    function mint(address _addr, uint _amount) public {
        if (maxSupply > 0 && safeAdd(totalSupply, _amount) > maxSupply) 
            revert();

        // Check for overflows        
        require(balanceOf[_addr] + _amount > balanceOf[_addr]);
        
        balanceOf[_addr] = safeAdd(balanceOf[_addr], _amount);
        totalSupply = safeAdd(totalSupply, _amount);

        //updating the maxSupply to new reduced value
        maxSupply = safeSub(maxSupply, _amount);
        Mint(_addr, _amount);
    }

    mapping(address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        //for avoiding under flow
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value > balanceOf[_to]);
        balanceOf[_from] = safeSub(balanceOf[_from], _value);

        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        Transfer(_from, _to, _value);
    }

    modifier onlyPayloadSize(uint numwords) {
        assert(msg.data.length == numwords * 32 + 4);
        _;
    } 

    function transfer(address _to, uint _value) 
    onlyPayloadSize(2)
    public returns (bool success) 
    {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) 
    onlyPayloadSize(3)
    public returns (bool success) 
    {
        if (balanceOf[_from] < _value) 
            return false; 

        var allowed = allowance[_from][msg.sender];
        if (allowed < _value) 
            return false;

        allowance[_from][msg.sender] = safeSub(allowed, _value);
        _transfer(_from, _to, _value);
        return true;
    }

    modifier notTokenCoinbase(address _from) {
        require (_from != tokenContractCoinbase);
        _;
    }

    function sendTokens(address _from, address _to, uint _value) 
    onlyPayloadSize(3)
    notTokenCoinbase(_from)
    public returns (bool success) 
    {
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) 
    onlyPayloadSize(2)
    public returns (bool success) 
    {
        //require user to set to zero before resetting to nonzero
        if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) {
            return false;
        }
    
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
    onlyPayloadSize(2) 
    constant 
    public returns (uint remaining) {
         return allowance[_owner][_spender];
    }

    function increaseApproval (address _spender, uint _addedValue) 
    onlyPayloadSize(2)
    public returns (bool success) 
    {
        uint oldValue = allowance[msg.sender][_spender];
        allowance[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
        return true;
    }

    function decreaseApproval (address _spender, uint _subtractedValue) 
    onlyPayloadSize(2)
    public returns (bool success) 
    {
        uint oldValue = allowance[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowance[msg.sender][_spender] = 0;
        } else {
            allowance[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
        }
        return true;
    }

    function burn(uint _amount) public returns (bool result) {
        //for avoiding under flow
        if (_amount > balanceOf[msg.sender]) 
            return false;

        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount);
        totalSupply = safeSub(totalSupply, _amount);
        //updating the maxSupply to new reduced value
        maxSupply = safeAdd(maxSupply, _amount);
        Burn(msg.sender, _amount);
        return true;
    }

    bool public flag = false;

    modifier onlyOnce() {
        if (flag == true)
            revert();
        _;
    }

    uint public maxSupply;

    function setMaxSupply(uint _maxSupply)
    onlyOnce 
    public {
        if (maxSupply > 0) 
            revert();
        maxSupply = _maxSupply;
        flag = true;
    }
}