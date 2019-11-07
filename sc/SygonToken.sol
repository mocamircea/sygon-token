pragma solidity 0.4.26;

contract SYGONtoken {
    address addrCreator;
    
    uint8 nTokenDecimals;
    string public sName;
    string public sSymbol;
    
    mapping (address => uint256) balances;
    
    // Delegate spenders
    mapping (address => mapping(address => uint256)) allowances;
    
    // Initial supply and quantities
    
    uint256 nInitialTotalSupply;
    uint256 nMaxTotalBurnableAmount;
    uint256 nTotalBurned;
    
    // Expenditure Destinations
    
    struct ExpDest{
        uint8 nID;
        address addr;
        uint8 nWeight;
    }

    mapping (string => ExpDest) expDestinations;
    
    // Events
    
    event ApproveDelegateSpender(address indexed addrSender, address indexed addrDelegateSpender, uint256 nApprovedAmount);
    event Transfer(address indexed addrSender, address indexed addrTo, uint256 nTransferredAmount);
    event TransferTokenRelease(address indexed addrTo, uint32 indexed nProjectID, uint32 indexed nExpDestination, uint8 nInstallmentNumber);
    event Burn(address indexed addrBurnFrom, uint256 nAmount);
    event ChangeEDAddress(string indexed sEDName, address indexed addrNewAddress);
    event ChangeEDWeight(string indexed sEDName, uint8 nNewWeight);
    
    modifier OnlyCreator () {
        require (msg.sender == addrCreator);
        _;
    }
    
    modifier ForbidInstantiator () {
        require (msg.sender != addrCreator);
        _;
    }
    
    modifier PreventBurn (address addr) {
        require (addr != address(0));
        _;
    }
    
    modifier NotToInstantiator (address addr) {
        require (addr != addrCreator);
        _;
    }
    
    modifier StrictPositive (uint256 nAmount) {
        require (nAmount > 0);
        _;
    }
    
    modifier IfValidReleaseAddress(address addrRelease) {
        require (addrRelease != addrCreator);
        
        require (addrRelease != expDestinations["PRO"].addr);
        require (addrRelease != expDestinations["OPR"].addr);
        require (addrRelease != expDestinations["ED3"].addr);
        require (addrRelease != expDestinations["ED4"].addr);
        
        require (addrRelease != address(0));
        _;
    }
    
    constructor() public {
        addrCreator = msg.sender;
        nTokenDecimals = 18;
        nInitialTotalSupply = 7500000000 * (uint256(10) ** nTokenDecimals);
        nMaxTotalBurnableAmount = 6750000000 * (uint256(10) ** nTokenDecimals);  // Maximum 90% of the total initial supply
        nTotalBurned = 0;
        balances[addrCreator] = nInitialTotalSupply;
        sName = "SYGON";
        sSymbol = "SYGON";
        
        // Expenditure Destinations
        
        // Explicit
        expDestinations["DEV"]=ExpDest(0,address(0),100);
        // Implicit
        expDestinations["PRO"]=ExpDest(1,address(0x0068559ead059468fdc19207e44c88836c2063ae0b),150);
        expDestinations["OPR"]=ExpDest(2,address(0x00e9d1dad223552122bbaf68adade73285aab3bc37),250);
        expDestinations["ED3"]=ExpDest(3,address(0),0); // Reserved for future implementations
        expDestinations["ED4"]=ExpDest(4,address(0),0);
    }
    
    function getInstantiator() public view returns(address addrInstantiatorAddress){
        return addrCreator;
    }
    
    function balanceOf(address addrTokenOwner) public view returns(uint256 nOwnerBalance) {
        return balances[addrTokenOwner];
    }
    
    function approve(address addrDelegateSpender, uint256 nAmount) public 
        ForbidInstantiator NotToInstantiator(addrDelegateSpender) returns(bool bApproveSuccess) {
        
        require(msg.sender != addrDelegateSpender);
        
        allowances[msg.sender][addrDelegateSpender] = nAmount;
        
        emit ApproveDelegateSpender(msg.sender, addrDelegateSpender, nAmount);
        
        return true;
    }
    
    function transfer(address addrTo, uint256 nAmount) public 
        ForbidInstantiator NotToInstantiator(addrTo) PreventBurn(addrTo) StrictPositive(nAmount) returns(bool bTransferSuccess) {
            
        bool bRetSuccess = false;
        
        require(balances[msg.sender] >= nAmount);
        executeTransfer(msg.sender,addrTo,nAmount);
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function transferFrom(address addrFrom, address addrTo, uint256 nAmount) public 
        ForbidInstantiator NotToInstantiator(addrTo) PreventBurn(addrTo) StrictPositive(nAmount) returns (bool bTransferFromSuccess) {
            
        bool bRetSuccess = false;
        
        require(balances[addrFrom] >= nAmount);
        require(allowances[addrFrom][msg.sender] >= nAmount);
        
        executeTransfer(addrFrom,addrTo,nAmount);
        allowances[addrFrom][msg.sender] -= nAmount;
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function transferAsTokenReleaseFromTotalSupply (address addrTo, uint256 nAmount_DEV, uint32 nProjectID, uint8 nInstallmentNumber) 
        OnlyCreator IfValidReleaseAddress(addrTo) StrictPositive(nAmount_DEV) public returns (bool bTransferTokenReleaseSuccess) {
        
        bool bRetSuccess = false;
        
        // Calculate amounts for implicit transfers
        
        uint256 nTotalAmount = nAmount_DEV;
        uint256 nAmount_PRO = (nAmount_DEV*expDestinations["PRO"].nWeight)/100;
        nTotalAmount += nAmount_PRO;
        uint256 nAmount_OPR = (nAmount_DEV*expDestinations["OPR"].nWeight)/100;
        nTotalAmount += nAmount_OPR;
        uint256 nAmount_ED3 = (nAmount_DEV*expDestinations["ED3"].nWeight)/100;
        nTotalAmount += nAmount_ED3;
        uint256 nAmount_ED4 = (nAmount_DEV*expDestinations["PR4"].nWeight)/100;
        nTotalAmount += nAmount_ED4;
        
        // Check availability from TRSR
        
        require(balances[msg.sender] >= nTotalAmount);
        
        // Transfer
        
        // To Explicit Destination: DEV
        executeTransfer(msg.sender, addrTo, nAmount_DEV);
        emit TransferTokenRelease(addrTo, nProjectID, 0, nInstallmentNumber);
        
        // To Implicit Destinations
        executeTransfer(msg.sender, expDestinations["PRO"].addr, nAmount_PRO);
        emit TransferTokenRelease(expDestinations["PRO"].addr, nProjectID, expDestinations["PRO"].nID, nInstallmentNumber);
        
        executeTransfer(msg.sender, expDestinations["OPR"].addr, nAmount_OPR);
        emit TransferTokenRelease(expDestinations["OPR"].addr, nProjectID, expDestinations["OPR"].nID, nInstallmentNumber);
        
        if(nAmount_ED3 > 0){
            executeTransfer(msg.sender, expDestinations["ED3"].addr, nAmount_ED3);
            emit TransferTokenRelease(expDestinations["ED3"].addr, nProjectID, expDestinations["ED3"].nID, nInstallmentNumber);
        }
        
        if(nAmount_ED4 > 0){
            executeTransfer(msg.sender, expDestinations["ED4"].addr, nAmount_ED4);
            emit TransferTokenRelease(expDestinations["ED4"].addr, nProjectID, expDestinations["ED4"].nID, nInstallmentNumber);
        }
        
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function executeTransfer(address addrFrom, address addrTo, uint256 nAmount) private {
        balances[addrFrom] -= nAmount;
        balances[addrTo] += nAmount;
        
        emit Transfer(addrFrom, addrTo, nAmount);
    }
    
    function getAllowanceForDelegateSpender(address addrOwner, address addrDelegateSpender) public view returns (uint256 nAmount) {
        return allowances[addrOwner][addrDelegateSpender];
    }
    
    function getTokenDecimals() public view returns (uint8 nDecimals) {
        return nTokenDecimals;
    }
    
    // Token burn
    
    function burn(uint256 nAmountToBurn) public 
        ForbidInstantiator returns (bool bBurnSuccess) {
        
        require (balances[msg.sender] >= nAmountToBurn);
        require (nAmountToBurn + nTotalBurned <= nMaxTotalBurnableAmount);
        
        balances[msg.sender] -= nAmountToBurn;
        nTotalBurned += nAmountToBurn;
        
        emit Burn(msg.sender, nAmountToBurn);
        
        return true;
    }
    
    
    // Supplies and Quantities
    
    function totalInitialSupply() public view returns(uint256 nTotalSupply){
        return nInitialTotalSupply;
    }
    
    function getSupplyInCirculation() public view returns (uint256 nTotalInCirculation) {
        return (nInitialTotalSupply - balances[addrCreator]) - nTotalBurned;
    }
    
    function getRemainingReleasableSupply() public view returns (uint256 nTotalRemainingReleasable) {
        return balances[addrCreator];
    }
    
    function getTotalBurned() public view returns (uint256 nTotalBurnedQuantity) {
        return nTotalBurned;
    }
    
    // Access Expenditure Destinations info
   
    function getAddressForExpDest(string sEDName) public view returns (address addrExpDestAddress) {
        return expDestinations[sEDName].addr;
    }
    
    function getIDForExpDest(string sEDName) public view returns (uint8 nExpDestID) {
        return expDestinations[sEDName].nID;
    }
    
    function getWeightForExpDest(string sEDName) public view returns (uint nExpDestWeight) {
        return expDestinations[sEDName].nWeight;
    }
    
    // Modify Expenditure Destinations
    
    function setAddressForExpDest(string sEDName, address addrNew) public
        OnlyCreator NotToInstantiator(addrNew) returns (bool bChangeEDAddressSuccess) {
            
        bool bRetSuccess = false;
        
        require(expDestinations[sEDName].nID >= 1 && expDestinations[sEDName].nID <= 4);
        
        expDestinations[sEDName].addr = addrNew;
        
        bRetSuccess = true;
        
        emit ChangeEDAddress(sEDName, addrNew);
        
        return bRetSuccess;
    }
    
    function setWeightForExpDest(string sEDName, uint8 nNewWeight) public
        OnlyCreator StrictPositive(nNewWeight) returns (bool bChangeEDWeightSuccess) {
            
        bool bRetSuccess = false;
        
        require(expDestinations[sEDName].nID >= 1 && expDestinations[sEDName].nID <= 4);
        
        expDestinations[sEDName].nID = nNewWeight;
        
        bRetSuccess = true;
        
        emit ChangeEDWeight(sEDName, nNewWeight);
        
        return bRetSuccess;
    }
}
