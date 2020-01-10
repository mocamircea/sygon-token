# UC22 Distribute and burn fee
## <i>distributeAndBurnFee</i>

The fee manager periodically distributes the fees collected at <i>addrFees</i> by burning a quota and transferring the rest to 
the operational entity. The value of quota is held by <i>nBurnFromFeeQuota</i>.

### Preconditions
Restrictions: only the Fee Manager can distribute and burn fees, the amount of collected fees exceed 100.

### Steps
Calculate the amount to burn. Burn the respective amount.

Transfer the reminder amount to "OPR" expenditure destination by delegating to <i>conditionalTransfer</i>.

### Postconditions
Returns true if the transfer and burn are completed successfully.
