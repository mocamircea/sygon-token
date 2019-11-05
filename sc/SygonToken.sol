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
    
    // Events
    event LogApproveDelegateSpender(address indexed addrSender, address indexed addrDelegateSpender, uint256 nApprovedAmount);
    event LogTransfer(address indexed addrSender, address indexed addrTo, uint256 nTransferredAmount);
    event LogTransferTokenIssue(address addrSender, address indexed addrTo, uint256 nTransferredAmount, uint32 indexed nProjectID, uint32 indexed nExpDestination, uint8 nInstallmentNumber);
    event LogTransferFrom(address indexed addrFrom, address indexed addrTo, address indexed sMsgSender);
    event LogBurn(address indexed addrBurnFrom, uint256 nAmount);
    
    constructor() public {
        addrInstantiator = msg.sender;
        nTokenDecimals = 18;
        nInitialTotalSupply = 7500000000 * (uint256(10) ** nTokenDecimals);
        nMaxTotalBurnableAmount = 6000000000 * (uint256(10) ** nTokenDecimals);  // Maximum 80% of the total initial supply
        nTotalBurned = 0;
        balances[addrInstantiator] = nInitialTotalSupply;
        sName = "SYGON";
        sSymbol = "SYGON";
    }
    
    function getInstantiator() public view returns(address addrInstantiatorAddress){
        return addrInstantiator;
    }
    
    function balanceOf(address addrTokenOwner) public view returns(uint256 nOwnerBalance) {
        return balances[addrTokenOwner];
    }
    
    function approve(address addrDelegateSpender, uint256 nAmount) public returns(bool bApproveSuccess) {
        require(msg.sender != addrDelegateSpender);
        require(msg.sender != addrInstantiator);
        require(addrDelegateSpender != addrInstantiator);
        
        allowances[msg.sender][addrDelegateSpender] = nAmount;
        
        emit LogApproveDelegateSpender(msg.sender, addrDelegateSpender, nAmount);
        
        return true;
    }
    
    function transfer(address addrTo, uint256 nAmount) public returns(bool bTransferSuccess) {
        bool bRetSuccess = false;
        
        require(msg.sender != addrInstantiator);
        require(addrTo != addrInstantiator);
        require(nAmount > 0);
        require(balances[msg.sender] >= nAmount);
        
        balances[msg.sender] -= nAmount;
        balances[addrTo] += nAmount;
            
        emit LogTransfer(msg.sender, addrTo, nAmount);
        
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function transferFrom(address addrFrom, address addrTo, uint256 nAmount) public returns (bool bTransferFromSuccess) {
        bool bRetSuccess = false;
        
        require(msg.sender != addrInstantiator);
        require(addrTo != addrInstantiator);
        require(nAmount > 0);
        require(balances[addrFrom] >= nAmount);
        require(allowances[addrFrom][msg.sender] >= nAmount);
        
        balances[addrFrom] -= nAmount;
        balances[addrTo] += nAmount;
        
        allowances[addrFrom][msg.sender] -= nAmount;
        
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function transferAsTokenReleaseFromTotalSupply(address addrTo, uint256 nAmount, uint32 nProjectID, uint32 nExpDestination, uint8 nInstallmentNumber) public returns (bool bTransferTokenIssueSuccess) {
        bool bRetSuccess = false;
        
        require(msg.sender == addrInstantiator);
        require(addrTo != addrInstantiator);
        require(nAmount > 0);
        require(balances[msg.sender] >= nAmount);
        
        balances[msg.sender] -= nAmount;
        balances[addrTo] += nAmount;
            
        emit LogTransferTokenIssue(msg.sender, addrTo, nAmount, nProjectID, nExpDestination, nInstallmentNumber);
        
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function getAllowanceForDelegateSpender(address addrOwner, address addrDelegateSpender) public view returns (uint256 nAmount) {
        return allowances[addrOwner][addrDelegateSpender];
    }
    
    function getTokenDecimals() public view returns (uint8 nDecimals) {
        return nTokenDecimals;
    }
    
    // SYGON token burn
    
    function burn(uint256 nAmountToBurn) public returns (bool bBurnSuccess) {
        require (msg.sender != addrInstantiator);
        require (balances[msg.sender] >= nAmountToBurn);
        require (nAmountToBurn + nTotalBurned <= nMaxTotalBurnableAmount);
        
        balances[msg.sender] -= nAmountToBurn;
        nTotalBurned += nAmountToBurn;
        
        emit LogBurn(msg.sender, nAmountToBurn);
        
        return true;
    }
    
    
    // Supplies and Quantities
    
    function totalInitialSupply() public view returns(uint256 nTotalSupply){
        return nInitialTotalSupply;
    }
    
    function getSupplyInCirculation() public view returns (uint256 nTotalSYGONTokenInCirculation) {
        return (nInitialTotalSupply - balances[addrInstantiator]) - nTotalBurned;
    }
    
    function getRemainingIssuableSupply() public view returns (uint256 nTotalSYGONTokenRemainingIssuable) {
        return balances[addrInstantiator];
    }
    
    function getTotalBurned() public view returns (uint256 nTotalSYGONTokenBurnedQuantity) {
        return nTotalBurned;
    }
}

