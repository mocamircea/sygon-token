pragma solidity 0.4.26;

contract SYGONtoken {
    address public addrCreator;
    
    uint8 public nDecimals;
    string public sName;
    string public sSymbol;
    
    mapping (address => uint256) balances;
    
    // Delegate spenders
    mapping (address => mapping(address => uint256)) allowances;
    
    // Supply and quantities
    
    uint256 nInitialTotalSupply;
    uint256 nMaxTotalBurnable;
    uint256 nTotalBurned;
    
    // Expenditure Destinations
    
    struct ExpDest{
        uint8 nID;
        address addr;
        uint8 nWeight;
    }

    mapping (string => ExpDest) expDestinations;
    
    // Burn mechanism
    bool public bBurnIsActive;
    
    // Fee
    bool public bFeeIsActive;
    address public addrFees;
    struct feeThreshold {
        uint256 threshold;
        uint256 factor;
    }
    mapping (uint8 => feeThreshold) feeSettings;
    address public addrFeeChanger;
    
    // Splitters
    struct SplitSchema {
        uint8 nTotal;
        mapping (address => uint8) dest;
        uint40 nExpiry;
    }
    mapping (address => SplitSchema) splitters;
    
    // Aliases
    mapping (address => uint40) aliases;
    
    address addrAliasTarget;
    
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
    
    modifier ForbidCreator () {
        require (msg.sender != addrCreator);
        _;
    }
    
    modifier PreventBurn (address addr) {
        require (addr != address(0));
        _;
    }
    
    modifier NotToCreator (address addr) {
        require (addr != addrCreator);
        _;
    }
    
    modifier StrictPositive (uint256 nAmount) {
        require (nAmount > 0);
        _;
    }
    
    modifier ValidReleaseAddress(address addrRelease) {
        require (addrRelease != addrCreator);
        
        require (addrRelease != expDestinations["PRO"].addr);
        require (addrRelease != expDestinations["OPR"].addr);
        require (addrRelease != expDestinations["ED3"].addr);
        require (addrRelease != expDestinations["ED4"].addr);
        
        require (addrRelease != address(0));
        _;
    }
    
    modifier NotReleaseAddress(address addrCheck) {
        require (addrCheck != expDestinations["DEV"].addr);
        require (addrCheck != expDestinations["PRO"].addr);
        require (addrCheck != expDestinations["OPR"].addr);
        require (addrCheck != expDestinations["ED3"].addr);
        require (addrCheck != expDestinations["ED4"].addr);
        _;
    }
    
    modifier OnlyImplicitDestination(string sEDName) {
        require(expDestinations[sEDName].nID >= 1 && expDestinations[sEDName].nID <= 4);
        _;
    }
    
    modifier BurnIsActive() {
        require(bBurnIsActive);
        _;
    }
    
    modifier NotAlias(address addrCheck) {
        require(aliases[addrCheck] == 0);
        _;
    }
    
    modifier NotFromAliasTarget(address addrCheck) {
        require(addrCheck != addrAliasTarget);
        _;
    }
    
    constructor() public {
        addrCreator = msg.sender;
        nDecimals = 18;
        nInitialTotalSupply = 7500000000 * (uint256(10) ** nDecimals);
        nMaxTotalBurnable = 6750000000 * (uint256(10) ** nDecimals);  // Maximum 90% of the total initial supply
        nTotalBurned = 0;
        balances[addrCreator] = nInitialTotalSupply;
        sName = "SYGON";
        sSymbol = "SYGON";
        
        // Expenditure Destinations
        
        // Explicit
        expDestinations["DEV"]=ExpDest(0,address(0),100); // Only for coherence with implicit destinations in getters
        // Implicit
        expDestinations["PRO"]=ExpDest(1,address(0x0068559ead059468fdc19207e44c88836c2063ae0b),150);
        expDestinations["OPR"]=ExpDest(2,address(0x00e9d1dad223552122bbaf68adade73285aab3bc37),250);
        expDestinations["ED3"]=ExpDest(3,address(0),0); // Reserved for future use
        expDestinations["ED4"]=ExpDest(4,address(0),0); // Reserved for future use
        
        // Burn
        bBurnIsActive = true; // For convenience
        
        // Fee
        bFeeIsActive = false;
        addrFees = address(0);
        addrFeeChanger = addrCreator;
        //feeSettings[0] = 
        
        
    }

    
    function balanceOf(address addrTokenOwner) public view returns(uint256 nOwnerBalance) {
        return balances[addrTokenOwner];
    }
    
    function getAllowanceForDelegateSpender(address addrOwner, address addrDelegateSpender) public view returns (uint256 nAmount) {
        return allowances[addrOwner][addrDelegateSpender];
    }
    
    function approve(address addrDelegateSpender, uint256 nAmount) public 
        ForbidCreator NotToCreator (addrDelegateSpender) returns(bool bApproveSuccess) {
        
        require(msg.sender != addrDelegateSpender);
        allowances[msg.sender][addrDelegateSpender] = nAmount;
        emit ApproveDelegateSpender(msg.sender, addrDelegateSpender, nAmount);
        
        return true;
    }
    
    // -----------------
    // TRANSFERS
    
    function transfer(address addrTo, uint256 nAmount) public 
        ForbidCreator NotToCreator(addrTo) PreventBurn(addrTo) StrictPositive(nAmount) NotFromAliasTarget(msg.sender) returns(bool bTransferSuccess) {

        require(balances[msg.sender] >= nAmount);
        
        // If not alias send to addrTo
        if(aliases[addrTo] == 0) {
            executeTransfer(msg.sender, addrTo, nAmount);
        }else {  // else, to alias target
            executeTransfer(msg.sender, addrAliasTarget, nAmount);
        }
        
        return true;
    }
    
    function transferFrom(address addrFrom, address addrTo, uint256 nAmount) public 
        ForbidCreator NotToCreator (addrTo) PreventBurn(addrTo) StrictPositive(nAmount) returns (bool bTransferFromSuccess) {
            
        bool bRetSuccess = false;
        
        require(balances[addrFrom] >= nAmount);
        require(allowances[addrFrom][msg.sender] >= nAmount);
        
        executeTransfer(addrFrom,addrTo,nAmount);
        allowances[addrFrom][msg.sender] -= nAmount;
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function transferAsTokenRelease (address addrTo, uint256 nAmount_DEV, uint32 nProjectID, uint8 nInstallmentID) 
        OnlyCreator ValidReleaseAddress(addrTo) StrictPositive(nAmount_DEV) public returns (bool bTransferTokenReleaseSuccess) {
        
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
        
        // Check availability from Total Remaining Supply to be Released (TRSR)
        
        require(balances[msg.sender] >= nTotalAmount);
        
        // Transfer
        
        // To Explicit Destination: DEV
        executeTransfer(msg.sender, addrTo, nAmount_DEV);
        emit TransferTokenRelease(addrTo, nProjectID, 0, nInstallmentID);
        
        // To Implicit Destinations
        executeTransfer(msg.sender, expDestinations["PRO"].addr, nAmount_PRO);
        emit TransferTokenRelease(expDestinations["PRO"].addr, nProjectID, expDestinations["PRO"].nID, nInstallmentID);
        
        executeTransfer(msg.sender, expDestinations["OPR"].addr, nAmount_OPR);
        emit TransferTokenRelease(expDestinations["OPR"].addr, nProjectID, expDestinations["OPR"].nID, nInstallmentID);
        
        if (nAmount_ED3 > 0) {
            executeTransfer(msg.sender, expDestinations["ED3"].addr, nAmount_ED3);
            emit TransferTokenRelease(expDestinations["ED3"].addr, nProjectID, expDestinations["ED3"].nID, nInstallmentID);
        }
        
        if (nAmount_ED4 > 0) {
            executeTransfer(msg.sender, expDestinations["ED4"].addr, nAmount_ED4);
            emit TransferTokenRelease(expDestinations["ED4"].addr, nProjectID, expDestinations["ED4"].nID, nInstallmentID);
        }
        
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    //function transferFromAliasTarget()
    
    function executeTransfer(address addrFrom, address addrTo, uint256 nAmount) private {
        balances[addrFrom] -= nAmount;
        balances[addrTo] += nAmount;
        
        emit Transfer(addrFrom, addrTo, nAmount);
    }

    
    // -----------------
    // TOKEN BURN
    
    function burn(uint256 nAmountToBurn) public 
        ForbidCreator BurnIsActive returns (bool bBurnSuccess) {
        
        bBurnSuccess = false;
        
        require (balances[msg.sender] >= nAmountToBurn);
        
        if (nAmountToBurn + nTotalBurned <= nMaxTotalBurnable) {
            balances[msg.sender] -= nAmountToBurn;
            nTotalBurned += nAmountToBurn;
        
            emit Burn(msg.sender, nAmountToBurn);
            bBurnSuccess = true;
        }else {
            if(nTotalBurned == nMaxTotalBurnable) {
                bBurnIsActive = false;
            }
        }
        
        return bBurnSuccess;
    }
    
    // -----------------
    // CALCULATIONS
    // 
    // Supplies and Quantities
    
    function totalInitialSupply() public view returns(uint256 nTotalSupply) {
        return nInitialTotalSupply;
    }
    
    function getCirculatingSupply() public view returns (uint256 nTotalInCirculation) {
        return (nInitialTotalSupply - balances[addrCreator]) - nTotalBurned;
    }
    
    function getRemainingReleasableSupply() public view returns (uint256 nTotalRemainingReleasable) {
        return balances[addrCreator];
    }
    
    function getTotalBurned() public view returns (uint256 nTotalBurnedQuantity) {
        return nTotalBurned;
    }
    
    // -----------------
    // EXPENDITURE DESTINATIONS
    
    // Access fields

    function getAddressForExpDest(string sEDName) public view returns (address addrExpDestAddress) {
        return expDestinations[sEDName].addr;
    }
    
    function getIDForExpDest(string sEDName) public view returns (uint8 nExpDestID) {
        return expDestinations[sEDName].nID;
    }
    
    function getWeightForExpDest(string sEDName) public view returns (uint nExpDestWeight) {
        return expDestinations[sEDName].nWeight;
    }
    
    // Modify Settings for Expenditure Destinations
    // Only Implicit Destinations can only have Address and Weight modified
    
    function setAddressForExpDest(string sEDName, address addrNew) public
        OnlyCreator NotToCreator(addrNew) OnlyImplicitDestination(sEDName) returns (bool bChangeEDAddressSuccess) {
            
        bool bRetSuccess = false;
        
        expDestinations[sEDName].addr = addrNew;
        bRetSuccess = true;
        
        emit ChangeEDAddress(sEDName, addrNew);
        
        return bRetSuccess;
    }
    
    function setWeightForExpDest(string sEDName, uint8 nNewWeight) public
        OnlyCreator StrictPositive(nNewWeight) OnlyImplicitDestination(sEDName) returns (bool bChangeEDWeightSuccess) {
            
        bool bRetSuccess = false;
        
        expDestinations[sEDName].nID = nNewWeight;
        bRetSuccess = true;
        
        emit ChangeEDWeight(sEDName, nNewWeight);
        
        return bRetSuccess;
    }
    
    // -----------------
    // FEE MECHANISM
    
    function calculateFee(uint256 nAmount) internal view
        returns(uint256 nFee) {
            
        if (bFeeIsActive){
            
        }else {
            nFee = nAmount +0;
        }
        
        return nFee;
    }
    
    function changeFeeChanger(address addrNewChanger) public returns (bool bChangeFeeChangerSuccess){
        bChangeFeeChangerSuccess = false;
        require(msg.sender == addrFeeChanger);
        addrFeeChanger = addrNewChanger;
        bChangeFeeChangerSuccess = true;
    }
    
    function changeFee(uint8 nFeeID, uint256 nNewFeeThreshold, uint8 nNewFeeFactor) public returns (bool bChangeFeeSuccess) {
        require(msg.sender == addrFeeChanger);
        require(nNewFeeThreshold > 0 && nNewFeeThreshold < getCirculatingSupply());
        feeSettings[nFeeID].threshold = nNewFeeThreshold;
        feeSettings[nFeeID].factor = nNewFeeFactor;
        bChangeFeeSuccess = true;
    }
    
    // -----------------
    // ALIASES
    
    // New Alias
    
    function addAlias() public 
        ForbidCreator NotAlias(msg.sender) NotReleaseAddress(msg.sender) returns (bool bAddAliasSuccess) {
        
        require(msg.sender != addrAliasTarget);
        aliases[msg.sender]=uint40(block.timestamp);
        
        return true;
    }
    
    // Change alias target
    
    function changeAliasTarget(address addrNewTarget) public 
        OnlyCreator NotToCreator(addrNewTarget) NotReleaseAddress(addrNewTarget) returns (bool bChangeAliasTargetSuccess) {
        
        addrAliasTarget = addrNewTarget;
        
        return true;
    }
    
    // Get alias creation tmstp
    
    function getForAlias(address addrSub) public view returns (uint40 tmstp) {
        return aliases[addrSub];
    }

}
