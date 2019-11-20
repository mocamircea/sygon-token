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
    
    uint256 public nInitialTotalSupply;
    uint256 public nMaxTotalBurnable;
    uint256 public nTotalBurned;
    
    // Expenditure Destination (for token release)
    
    struct ExpDestSetting{
        uint8 nID;
        address addr;
        uint8 nWeight;
    }

    mapping (string => ExpDestSetting) expDestinations;
    
    // Burn mechanism -- For checking convenience
    bool public bBurnIsActive;
    
    // Fee mechanism
    //bool public bFeeIsActive;
    address public addrFees; // Collected fees
    uint8 public nBurnFromFeeQuota; // Quota to burn from collected fees
    
    // Implement fee thresholds according to amount intervals
    struct feeSetting {
        uint256 nAmount;
        uint256 nFactor;
        uint256 nDecimals;
    }
    
    mapping (uint8 => feeSetting) feeSettings;
    //address public addrFeeManager;
    
    
    // Splitters
    struct SplitWeight {
        address addr;
        uint8 weight;
    }
    
    struct SplitSchema {
        SplitWeight[] destinations;
        uint40 nExpiry; // not used 11.19.2019
    }
    
    mapping (address => SplitSchema) splitters;
    
    
    // Aliases
    mapping (address => uint40) aliases;
    address public addrAliasTarget;
    
    
    event ApproveDelegateSpender(address indexed addrSender, address indexed addrDelegateSpender, uint256 nApprovedAmount);
    event Transfer(address indexed addrSender, address indexed addrTo, uint256 nTransferredAmount, bool indexed bIsFee);
    event TransferTokenRelease(address indexed addrTo, uint32 indexed nProjectID, uint32 indexed nExpDestination, uint8 nInstallmentNumber);
    event Burn(address indexed addrBurnFrom, uint256 nAmount);
    event ChangeEDAddress(string indexed sEDName, address indexed addrNewAddress);
    event ChangeEDWeight(string indexed sEDName, uint8 nNewWeight);
    event ChangeBurnFromFeeQuota(address indexed addrFeeManager, uint8 nNewQuota);
    event ChangeFeesAddress(address indexed addrNewAddress);
    
    
    modifier OnlyCreator () {
        require (msg.sender == addrCreator);
        _;
    }
    
    modifier ForbidCreator () {
        require (msg.sender != addrCreator);
        _;
    }
    
    modifier PreventBurn (address addr) {
        require (addr != address(0x0));
        _;
    }
    
    modifier NotCreator (address addr) {
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
        
        require (addrRelease != addrFees);
        
        require (addrRelease != addrAliasTarget);
        
        require (! isSplitter(addrRelease));
        
        require (addrRelease != address(0x0));
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
    
    modifier NotAliasTarget(address addrCheck) {
        require(addrCheck != addrAliasTarget);
        _;
    }
    
    modifier NotFromFees(address addrFrom) {
        require(addrFrom != addrFees);
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
        expDestinations["DEV"]=ExpDestSetting(0,address(0x0),100); // Only for coherence with implicit destinations in getters, address is never used
        // Implicit
        expDestinations["PRO"]=ExpDestSetting(1,address(0x0068559ead059468fdc19207e44c88836c2063ae0b),150);
        expDestinations["OPR"]=ExpDestSetting(2,address(0x00e9d1dad223552122bbaf68adade73285aab3bc37),250);
        expDestinations["ED3"]=ExpDestSetting(3,address(0),0); // Reserved for future use
        expDestinations["ED4"]=ExpDestSetting(4,address(0),0); // Reserved for future use
        
        // Burn
        bBurnIsActive = true;
        
        // Fee
        addrFees = address(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        //addrFeeManager = addrCreator;  // Initially the creator, then changed to 
        
        // 3 Fee intervals based on transferred amount
        feeSettings[0] = feeSetting(1000000000000000000000,15,4);
        feeSettings[1] = feeSetting(10000000000000000000000,90,4);
        feeSettings[2] = feeSetting(0,5,6);
        nBurnFromFeeQuota = 100;
        
        // Alias target
        addrAliasTarget = address(0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C);
        
    }
    
    function balanceOf(address addrTokenOwner) public view returns(uint256 nOwnerBalance) {
        return balances[addrTokenOwner];
    }
    
    function getAllowanceForDelegateSpender(address addrOwner, address addrDelegateSpender) public view returns (uint256 nAmount) {
        return allowances[addrOwner][addrDelegateSpender];
    }
    
    function approve(address addrDelegateSpender, uint256 nAmount) public 
        ForbidCreator NotCreator(addrDelegateSpender) returns(bool bApproveSuccess) {
        
        require(msg.sender != addrDelegateSpender);
        allowances[msg.sender][addrDelegateSpender] = nAmount;
        emit ApproveDelegateSpender(msg.sender, addrDelegateSpender, nAmount);
        
        bApproveSuccess = true;
    }
    
    
    // -----------------
    // TRANSFERS
    
    function transfer(address addrTo, uint256 nAmount) public 
        ForbidCreator NotCreator(addrTo) PreventBurn(addrTo) StrictPositive(nAmount) NotAliasTarget(msg.sender) NotFromFees(msg.sender) returns(bool bTransferSuccess) {

        require(balances[msg.sender] >= nAmount);
    
        if(conditionalTransfer(msg.sender, addrTo, nAmount)) {
            bTransferSuccess = true;
        }
    }
    
    function transferFrom(address addrFrom, address addrTo, uint256 nAmount) public 
        ForbidCreator NotCreator(addrFrom) NotCreator(addrTo) PreventBurn(addrTo) StrictPositive(nAmount) NotAliasTarget(addrFrom) NotFromFees(addrFrom) returns (bool bTransferFromSuccess) {
        
        require(balances[addrFrom] >= nAmount);
        require(allowances[addrFrom][msg.sender] >= nAmount);
        
        if(conditionalTransfer(addrFrom, addrTo, nAmount)) {
        //executeTransfer(addrFrom,addrTo,nAmount);
            allowances[addrFrom][msg.sender] -= nAmount;
            bTransferFromSuccess = true;
        }
    }
    
    function conditionalTransfer(address addrFrom, address addrTo, uint256 nAmount) private returns (bool bConditionalTransferSuccess) {
        if(aliases[addrTo] == 0) {  // If not an alias
            if(! isSplitter(addrTo)) { // and not splitter
                executeTransfer(addrFrom, addrTo, nAmount);  // send "nAmount" to "addrTo"
                bConditionalTransferSuccess = true;
            }else{
                if(splitWeightsValid(addrTo)) {  // check if splitter is correctly defined
                    executeTransfer(addrFrom, addrTo, nAmount);
                    transferSplit(addrTo, nAmount);
                    bConditionalTransferSuccess = true;
                }
            }
        }else {  // send to alias target
            executeTransfer(addrFrom, addrAliasTarget, nAmount);
            bConditionalTransferSuccess = true;
        }
    }
    
    function transferAsTokenRelease (address addrTo, uint256 nAmount_DEV, uint32 nProjectID, uint8 nInstallmentID) 
        OnlyCreator ValidReleaseAddress(addrTo) StrictPositive(nAmount_DEV) public returns (bool bTransferTokenReleaseSuccess) {
        
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
        
        bTransferTokenReleaseSuccess = true;
    }
    
    function transferSplit(address addrFrom, uint256 nAmount) internal {
        
            uint256 nCalcAmount = (nAmount * splitters[addrFrom].destinations[0].weight)/100;
            executeTransfer(addrFrom, splitters[addrFrom].destinations[0].addr, nCalcAmount);
            nCalcAmount = nAmount-nCalcAmount;
            
            for(uint8 i = 1; i<=6; i++){
                if(splitters[addrFrom].destinations[i].weight>0){
                    executeTransfer(addrFrom, splitters[addrFrom].destinations[i].addr, (nCalcAmount*splitters[addrFrom].destinations[i].weight)/100);
                }
            }
    }
    
    function transferFromAliasTarget(address addrTo, uint256 nAmount) public 
        StrictPositive(nAmount) returns(bool bTransferFromAliasTargetSuccess) {
        
        require(msg.sender == addrAliasTarget || allowances[addrAliasTarget][msg.sender]>0);
        require(isSplitter(addrTo));
        require(balances[addrAliasTarget] >= nAmount);
        
        if(msg.sender == addrAliasTarget){
           executeTransfer(addrAliasTarget, addrTo, nAmount);
           bTransferFromAliasTargetSuccess = true;
        }else{ // delegated transfer
            if(allowances[addrAliasTarget][msg.sender]>=nAmount){
                executeTransfer(addrAliasTarget, addrTo, nAmount);
                allowances[addrAliasTarget][msg.sender] -= nAmount;
                bTransferFromAliasTargetSuccess = true;
            }
        }
    }
    //
    
    function executeTransfer(address addrFrom, address addrTo, uint256 nAmount) private {
        // Calculate FEE
        uint256 nFee = calculateFee(nAmount);
        uint256 nNetAmount = nAmount-nFee;
        
        // Transfer net amount
        balances[addrFrom] -= nNetAmount;
        balances[addrTo] += nNetAmount;
        emit Transfer(addrFrom, addrTo, nAmount, false);
        
        // Transfer fee
        if(nFee>0){
            balances[addrFrom] -= nFee;
            balances[addrFees] += nFee;
            emit Transfer(addrFrom, addrFees, nFee, true);
        }
    }

    
    // -----------------
    // TOKEN RELEASE - EXPENDITURE DESTINATIONS
    
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
        OnlyCreator NotCreator(addrNew) OnlyImplicitDestination(sEDName) returns (bool bChangeEDAddressSuccess) {
        
        expDestinations[sEDName].addr = addrNew;
        bChangeEDAddressSuccess = true;
        
        emit ChangeEDAddress(sEDName, addrNew);
    }
    
    function setWeightForExpDest(string sEDName, uint8 nNewWeight) public
        OnlyCreator StrictPositive(nNewWeight) OnlyImplicitDestination(sEDName) returns (bool bChangeEDWeightSuccess) {
        
        expDestinations[sEDName].nID = nNewWeight;
        bChangeEDWeightSuccess = true;
        
        emit ChangeEDWeight(sEDName, nNewWeight);
    }
    
    
    // -----------------
    // FEE
    
    function calculateFee(uint256 nAmount) public view
        returns(uint256 nFee) {
            
        //if (bFeeIsActive){ // todo: needed?
            if (nAmount > 0 && nAmount <= feeSettings[0].nAmount) {
                nFee = (nAmount * feeSettings[0].nFactor)/(uint256(10)**feeSettings[0].nDecimals);
            }else{
                if (nAmount > feeSettings[0].nAmount && nAmount <= feeSettings[1].nAmount) {
                    nFee = (nAmount * feeSettings[1].nFactor)/(uint256(10)**feeSettings[1].nDecimals);
                }else{
                    if (nAmount > feeSettings[1].nAmount) {
                        nFee = (nAmount * feeSettings[2].nFactor)/(uint256(10)**feeSettings[2].nDecimals);
                    }
                }
            }
        /*}else {
            nFee = 0;
        }*/
    }
    
    function changeFeesAddr(address addrNew) public returns (bool bChangeFeesAddrSuccess) {
        require(msg.sender == addrFees);
        require(distributeAndBurnFee());
        addrFees = addrNew;
        emit ChangeFeesAddress(addrNew);
        bChangeFeesAddrSuccess = true;
    }
    
    function changeFeeSetting(uint8 nFeeID, uint256 nNewAmount, uint8 nNewFactor, uint8 nNewDecimals) public returns (bool bChangeFeeSuccess) {
        require(msg.sender == addrFees);
        require(nFeeID>=0 && nFeeID<=2);
        require(nNewAmount > 0 && nNewAmount < getCirculatingSupply());
        feeSettings[nFeeID].nAmount = nNewAmount;
        feeSettings[nFeeID].nFactor = nNewFactor;
        feeSettings[nFeeID].nDecimals = nNewDecimals;
        
        bChangeFeeSuccess = true;
    }
    
    function changeBurnFromFeeQuota(uint8 nQuota) public returns (bool bChangeBurnFromFeeQuotaSuccess) {
        require(msg.sender==addrFees);
        require(nQuota>=20 && nQuota<=100);
        nBurnFromFeeQuota = nQuota;
        emit ChangeBurnFromFeeQuota(addrFees, nQuota);
        
        bChangeBurnFromFeeQuotaSuccess = true;
    }
    
    function distributeAndBurnFee() public returns (bool bDistrAndBurnFeeSuccess) {
        require(msg.sender==addrFees);
        // Calculate amount to Burn
        if(balances[addrFees]>=100){
            uint256 nAmountToBurn = (balances[addrFees]*nBurnFromFeeQuota)/100;
            burn(nAmountToBurn);
            if(conditionalTransfer(msg.sender, expDestinations["OPR"].addr, balances[addrFees]-nAmountToBurn)){
                bDistrAndBurnFeeSuccess = true;
            }
        }
    }
    
    
    // -----------------
    // ALIASES
    
    // Add new alias
    
    function addAlias() public 
        ForbidCreator NotAlias(msg.sender) NotReleaseAddress(msg.sender) returns (bool bAddAliasSuccess) {
        
        require(msg.sender != addrAliasTarget);
        aliases[msg.sender]=uint40(block.timestamp);
        
        return true;
    }
    
    // Change alias target
    
    function changeAliasTarget(address addrNewTarget) public 
        OnlyCreator NotCreator(addrNewTarget) NotAlias(addrNewTarget) NotReleaseAddress(addrNewTarget) returns (bool bChangeAliasTargetSuccess) {
        
        addrAliasTarget = addrNewTarget;
        
        return true;
    }
    
    // Get alias creation timestamp
    
    function getForAlias(address addr) public view returns (uint40 tmstp) {
        return aliases[addr];
    }


    // -----------------
    // SPLITTERS
    
    // Add new splitter
    
    function addSplitter(address addrDest1, uint8 w1, address addrDest2) public returns (bool bAddSplitterSuccess) {
        require(msg.sender != addrDest1);
        require(msg.sender != addrDest2);
        require(addrDest1 != addrDest2);
        require(w1>0 && w1<=100);
        
        splitters[msg.sender].destinations.push(SplitWeight(addrDest1,w1));
        splitters[msg.sender].destinations.push(SplitWeight(addrDest2,100-w1));
        splitters[msg.sender].destinations.push(SplitWeight(address(0x0),0));
        splitters[msg.sender].destinations.push(SplitWeight(address(0x0),0));
        splitters[msg.sender].destinations.push(SplitWeight(address(0x0),0));
        splitters[msg.sender].destinations.push(SplitWeight(address(0x0),0));
        splitters[msg.sender].destinations.push(SplitWeight(address(0x0),0));
        splitters[msg.sender].nExpiry = 1;
        
        return true;
    }
    
    // Configure a splitter
    
    function configSplitter(address addrSplitted, uint8 nPos, address addrDest, uint8 nWeight) public returns (bool bSetSplitterSuccess) {
        if(msg.sender == addrSplitted && nPos == 0){
            splitters[addrSplitted].destinations[nPos] = SplitWeight(addrDest, nWeight);
            bSetSplitterSuccess = true;
        }else{
            if(msg.sender == splitters[addrSplitted].destinations[1].addr && nPos >= 2 && nPos <= 6){
                splitters[addrSplitted].destinations[nPos] = SplitWeight(addrDest, nWeight);
                bSetSplitterSuccess = true;
            }
        }
    }
    
    // Change own address in splitter
    
    function changeDestinationInSplitter(address addrSplitted, address addrNew) public returns (bool bChangeDestInSplitterSuccess) {
        for (uint i = 0; i<=6; i++){
            if(splitters[addrSplitted].destinations[i].addr == msg.sender) {
                splitters[addrSplitted].destinations[i].addr = addrNew;
                bChangeDestInSplitterSuccess = true;
                break;
            }
        }
    }
    
    // Check if split weights are valid
    
    function splitWeightsValid(address addrSplitted) public view returns (bool bSplitWeightsAreValid) {
        if(splitters[addrSplitted].destinations[0].weight>0 && splitters[addrSplitted].destinations[0].weight<=99){
            uint8 sum = 0;
            for (uint8 i=1; i<=6; i++){
                sum += splitters[addrSplitted].destinations[i].weight;
            }
            if(sum == 100){
                bSplitWeightsAreValid = true;
            }
        }
    }
    
    // Check if splitter
    
    function isSplitter(address addr) public view returns (bool bAddrIsSplitter) {
        return splitters[addr].nExpiry != 0;
    }
    
    
    // -----------------
    // TOKEN BURN
    
    function burn(uint256 nAmountToBurn) public 
        ForbidCreator BurnIsActive returns (bool bBurnSuccess) {
        
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
    }
    
    
    // -----------------
    // CALCULATIONS
    // 
    // Supplies and Quantities
    
    function getCirculatingSupply() public view returns (uint256 nTotalInCirculation) {
        return (nInitialTotalSupply - balances[addrCreator]) - nTotalBurned;
    }
    
    function getRemainingReleasableSupply() public view returns (uint256 nTotalRemainingReleasable) {
        return balances[addrCreator];
    }
    
}
