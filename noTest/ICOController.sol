pragma solidity ^0.4.15;

import "./Common.sol";
import "./Token.sol"; 
import "./ICO.sol";
import "./ICOSale.sol";

contract ICOController is SafeMath, Owned, Constants {
    ICO public ico;
    uint weiPerDollar;
    address advisor;

    ICOSaleLauncher icoSaleLauncher;
    
    function setICOSaleLauncher(address a) onlyOwner setupNotComplete {
        icoSaleLauncher = ICOSaleLauncher(a);
    }
    
    function ICOController() {
        owner = msg.sender;
    }

    function setICO(address _ico) 
    onlyOwner 
    setupNotComplete 
    {
        ico = ICO(_ico);
    }

    function setAdvisor(address _advisor) onlyOwner {
        if (advisor != address(0)) 
            throw;
        advisor = _advisor;
    }

    // //============================================================================================
    // //=========================================== Test Methods ===================================
    
    function getAdvisorAddress() returns (address){
        return advisor;
    }
    
    function getAddressZero() returns (address){
        return address(0);
    }

    // //============================================================================================

    function setupComplete() private returns (bool) {
        return (
            address(icoSaleLauncher) != address(0) && 
            address(ico) != address(0) &&
            address(ico.token()) != address(0));
    }

    modifier setupIsComplete() {
        if (!setupComplete()) 
            throw;
        _;
    }

    modifier setupNotComplete() {
        if (setupComplete()) 
            throw;
        _;
    }

    modifier firstSaleComplete() {
        if (!ico.sales(0).isComplete(ico.currTime())) 
            throw;
        _;
    }

    modifier onlyICO() {
        if (msg.sender != address(ico)) 
            throw;
        _;
    }

    function startICOSale(uint _weiPerDollar) onlyOwner setupIsComplete {
        weiPerDollar = _weiPerDollar;
        address firstsale = icoSaleLauncher.launch(address(ico), weiPerDollar, ico.weiPerEth(), ico.currTime());
        ico.addSale(firstsale);
    }

    function getCurrSale() constant returns (uint) {
        if (ico.numSales() == 0) 
            throw; //no reason to call before startFirstSale
        return ico.numSales() - 1;
    }

    function currSaleIsActive() constant returns (bool) {
        return ico.sales(getCurrSale()).isActive(ico.currTime());
    }

    function advisorTokens() constant returns (uint) {
        uint time = ico.currTime();
        uint tokens;
        if (ico.sales(0).isComplete(time)) {
            tokens = ico.sales(0).getSoldTokens() / 12;
        }
        return tokens;
    }

    function ownerTokens() constant returns (uint) {
        uint time = ico.currTime();
        uint tokens;
        if (ico.sales(0).isComplete(time)) {
            tokens = ico.sales(0).getSoldTokens() / 3;
        }
        return tokens;
    }

    function totalTokenSupply() constant returns (uint) {
        uint time = ico.currTime();
        uint totalTokens = ico.sales(0).getSoldTokens();
        if (ico.sales(0).isComplete(time)) {
            totalTokens = safeAdd(totalTokens, ownerTokens());
            totalTokens = safeAdd(totalTokens, advisorTokens());
        }
        return totalTokens;
    }

    //allow non-auction sales
    function launchSale(address _sale) 
    onlyOwner 
    setupIsComplete 
    {
        //can't launch a sale unless previous sale is complete
        if (!ico.sales(getCurrSale()).isComplete(ico.currTime())) 
            throw;

        //can't launch unless token has its max set
        //token will refuse to mint excess this way
        if (ico.token().maxSupply() == 0) 
            throw;

        ico.addSale(_sale);
    }

}