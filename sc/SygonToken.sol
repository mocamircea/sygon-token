pragma solidity 0.4.25;

contract SYGONtoken {
    mapping (address => uint256) balances;
    
    mapping (address => mapping(address => uint256)) allowed;
    
    uint256 nTotalSYGONTokenSupply = 7500000000;
    
    address addrInstantiator;
    
    uint8 nNumberOfDecimals = 18; 
    
    // Events
    event LogApproveDelegateSpender(address indexed addrSender, address indexed addrDelegateSpender, uint256 nApprovedAmount);
    event LogTransfer(address indexed addrSender, address indexed addrTo, uint256 nTransferredAmount);
    event LogTransferTokenIssue(address addrSender, address indexed addrTo, uint256 nTransferredAmount, uint32 indexed nProjectID, uint32 indexed nExpDestination, uint8 nInstallmentNumber);
    event LogTransferFrom(address indexed addrFrom, address indexed addrTo, address indexed sMsgSender);
    
    constructor() public payable{
        addrInstantiator = msg.sender;
        balances[addrInstantiator] = nTotalSYGONTokenSupply;
    }
    
    function totalSupply() public view returns(uint256 nTotalSupply){
        return nTotalSYGONTokenSupply;
    }
    
    function getInstantiator() public view returns(address addrOwnrAddr){
        return addrInstantiator;
    }
    
    function balanceOf(address addrTokenOwner) public view returns(uint256 nOwnerBalance) {
        return balances[addrTokenOwner];
    }
    
    function approve(address addrDelegateSpender, uint256 nAmount) public returns(bool bApproveSuccess) {
        require(msg.sender != addrDelegateSpender);
        require(msg.sender != addrInstantiator);
        require(addrDelegateSpender != addrInstantiator);
        
        allowed[msg.sender][addrDelegateSpender] = nAmount;
        
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
    
    function transferTokenIssue(address addrTo, uint256 nAmount, uint32 nProjectID, uint32 nExpDestination, uint8 nInstallmentNumber) public returns (bool bTransferTokenIssueSuccess) {
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
    
    function transferFrom(address addrFrom, address addrTo, uint256 nAmount) public returns (bool bTransferFromSuccess) {
        bool bRetSuccess = false;
        
        require(msg.sender != addrInstantiator);
        require(addrTo != addrInstantiator);
        require(nAmount > 0);
        require(balances[addrFrom] >= nAmount);
        require(allowed[addrFrom][msg.sender] >= nAmount);
        
        balances[addrFrom] -= nAmount;
        balances[addrTo] += nAmount;
        
        allowed[addrFrom][msg.sender] -= nAmount;
        
        bRetSuccess = true;
        
        return bRetSuccess;
    }
    
    function getAllowanceForDelegateSpender(address addrOwner, address addrDelegateSpender) public view returns (uint256 nAmount) {
        return allowed[addrOwner][addrDelegateSpender];
    }
    
    function getTokenName() public pure returns (string sTokenName) {
        return "SYGON";
    }
    
    function getTokenSymbol() public pure returns (string sTokenSymbol) {
        return "SYGON";
    }
    
    function getNumberOfDecimals() public view returns (uint8 nDecimals) {
        return nNumberOfDecimals;
    }
    
    function getTotalSYGONTokenInCirculation() public view returns (uint256 nTotalSYGONTokenInCirculation) {
        return nTotalSYGONTokenSupply - balances[addrInstantiator];
    }
}

