pragma solidity 0.4.25;

contract SYGONtoken {
    address addrInstantiator;
    
    uint8 nTokenDecimals;
    string public sName;
    string public sSymbol;
    
    mapping (address => uint256) balances;
    
    mapping (address => mapping(address => uint256)) allowances;  // Delegate spenders
    
    // Initial supply and quantities
    uint256 nInitialTotalSupply;
    uint256 nMaxTotalBurnableAmount;
    uint256 nTotalBurned;
    
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
    
    modifier OnlyInstantiator () {
        require (msg.sender == addrInstantiator);
        _;
    }
    
    modifier ForbidInstantiator () {
        require (msg.sender != addrInstantiator);
        _;
    }
    
    modifier PreventBurn (address addr) {
        require (addr != address(0));
        _;
    }
    
    modifier NotToInstantiator (address addr) {
        require (addr != addrInstantiator);
        _;
    }
    
    modifier Positive (uint256 nAmount) {
        require(nAmount > 0);
        _;
    }
    
    constructor() public {
        addrInstantiator = msg.sender;
        nTokenDecimals = 18;
        nInitialTotalSupply = 7500000000 * (uint256(10) ** nTokenDecimals);
        nMaxTotalBurnableAmount = 6000000000 * (uint256(10) ** nTokenDecimals);  // Maximum 80% of the total initial supply
        nTotalBurned = 0;
        balances[addrInstantiator] = nInitialTotalSupply;
        sName = "SYGON";
        sSymbol = "SYGON";
        
        // Implicit Expenditure Destinations
        expDestinations["PRO"]=ExpDest(1,address(0x68559ead059468fdc19207e44c88836c2063ae0b),15);
        expDestinations["OPR"]=ExpDest(2,address(0xe9d1dad223552122bbaf68adade73285aab3bc37),25);
        expDestinations["ED3"]=ExpDest(3,address(0),0); // Reserved for future implementations
        expDestinations["ED4"]=ExpDest(4,address(0),0);
    }
    
    function getInstantiator() public view returns(address addrInstantiatorAddress){
        return addrInstantiator;
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
        ForbidInstantiator NotToInstantiator(addrTo) PreventBurn(addrTo) Positive(nAmount) returns(bool bTransferSuccess) {
            
        bool bRetSuccess = false;
        
        require(balances[msg.sender] >= nAmount);
        
        executeTransfer(msg.sender,addrTo,nAmount);
        
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function transferFrom(address addrFrom, address addrTo, uint256 nAmount) public 
        ForbidInstantiator NotToInstantiator(addrTo) PreventBurn(addrTo) Positive(nAmount) returns (bool bTransferFromSuccess) {
            
        bool bRetSuccess = false;
        
        require(balances[addrFrom] >= nAmount);
        require(allowances[addrFrom][msg.sender] >= nAmount);
        

        executeTransfer(addrFrom,addrTo,nAmount);
        
        allowances[addrFrom][msg.sender] -= nAmount;
        
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function transferAsTokenReleaseFromTotalSupply (address addrTo, uint256 nAmount_DEV, uint32 nProjectID, uint8 nInstallmentNumber) 
        OnlyInstantiator NotToInstantiator(addrTo) PreventBurn(addrTo) Positive(nAmount_DEV) public returns (bool bTransferTokenReleaseSuccess) {
        
        bool bRetSuccess = false;
        
        // Calculate amounts for implicit transfers
        
        uint256 nTotalAmount = nAmount_DEV;
        uint256 nAmount_PRO = (nAmount_DEV*expDestinations["PRO"].nWeight)/10;
        nTotalAmount += nAmount_PRO;
        uint256 nAmount_OPR = (nAmount_DEV*expDestinations["OPR"].nWeight)/10;
        nTotalAmount += nAmount_OPR;
        uint256 nAmount_ED3 = (nAmount_DEV*expDestinations["ED3"].nWeight)/10;
        nTotalAmount += nAmount_ED3;
        uint256 nAmount_ED4 = (nAmount_DEV*expDestinations["PR4"].nWeight)/10;
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
    
    // SYGON token burn
    
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
        return (nInitialTotalSupply - balances[addrInstantiator]) - nTotalBurned;
    }
    
    function getRemainingReleasableSupply() public view returns (uint256 nTotalRemainingReleasable) {
        return balances[addrInstantiator];
    }
    
    function getTotalBurned() public view returns (uint256 nTotalBurnedQuantity) {
        return nTotalBurned;
    }
    
    function calctest() public view returns(uint256 result){
        return ((10000*(uint256(10)**nTokenDecimals)*15)/10) / (uint256(10)**nTokenDecimals);
    }
}

