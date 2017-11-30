pragma solidity >=0.4.15;

import './Common.sol';
import './Token.sol';

contract TokenController is SafeMath, Owned, Constants {

    Token token;
    address private tokenContractCoinbase = 0x0270a33e6ac28b8c1d444bb5eab3ad1d453e4d5f;

    function TokenController() public {
        owner = msg.sender;
    }

    function setToken(address _token)
    onlyOwner 
    public {
        token = Token(_token);
    }

    uint256 public sellPrice;
    uint256 public buyPrice;

    function setPricesForTokensPerEth(uint256 newSellPriceTokensPerEth, uint256 newBuyPriceTokensPerEth) 
    onlyOwner 
    public 
    {
        sellPrice = newSellPriceTokensPerEth;
        buyPrice = newBuyPriceTokensPerEth;
    }


    function () payable public {
        /// this method should not be used from the coinbase to transfer coins
        if (msg.sender != tokenContractCoinbase) {
            buyTokens();       
        } 
    }

    function payEthersToContract() payable public {
        // do nothing ut only stores ether to this contract
    }

    function buyTokens() payable public {
        uint amount = calculateTokensPerWeiFromBuyPrice(msg.value);    /// calculates the amount 
        token.mint(msg.sender, amount);   /// makes the transfers 
        ///sending received ethers to the coinbase
        /// escaping the possibility of reentrancy attack
        tokenContractCoinbase.transfer(msg.value);           
    }

    function calculateTokensPerWeiFromBuyPrice(uint _weiAmount) private returns (uint) {
        uint tokenAmount;
        uint ethers;
        uint remainingWeis;
        uint etherFraction;

        ethers = getEthersFromWei(_weiAmount); // dividing buy 10e+18
        remainingWeis = _weiAmount % 1000000000000000000; // dividing buy 10e+18
        etherFraction = remainingWeis / 10000000000000000; // 100th of an ether like anything in fraction upto 2 digits

        tokenAmount = (ethers * buyPrice) + ( etherFraction * (buyPrice / 100) );
        return tokenAmount;
    }

    function calculateWeisForTokensToSell(uint _tokenAmount) private returns (uint) {
        uint priceOfOneToken = 1000000000000000000 / sellPrice;
        uint weiAmount = priceOfOneToken * _tokenAmount;
        return weiAmount;
    }

    function getEthersFromWei(uint _weiAmount) private returns (uint) {
        return _weiAmount / 1000000000000000000;
    }

    function getRemainingFractionalEthersFromWei(uint _weiAmount) private returns (uint) {
        return _weiAmount % 1000000000000000000; // dividing buy 10e+18
    }

    function sell() payable public {
        uint weis = calculateWeisForTokensToSell(msg.value);
        token.sendTokens(msg.sender, tokenContractCoinbase, msg.value);        
        msg.sender.transfer(weis); 
    }

    function transferFrom(address _from, address _to, uint _value)
    public returns (bool success) 
    {
        bool flag = token.transferFrom(_from, _to, _value);
        return flag;
    }
}