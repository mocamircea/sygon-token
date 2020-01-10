# UC9 Delegated transfer
## <i>transferFrom</i>

### Preconditions
The transfer can not be performed by the Creator or from Creator's balance, 
Creator can not be recipient of the transfer, the amount to transfer is not burned, the transferred amount is strictly positive, 
the transfer can not be made from <i>addrAliasTarget</i> or <i>addrFees</i>.

The balance to be debited must cover the transferred amount.

The allowance for the sender must cover the transferred amount.

### Steps
The transfer is delegated to <i>conditionalTransfer</i> and if the transfer is successful, 
the allowance for the sender is reduced with the 
tranferred amount.

### Postconditions
The balances of: the source of transfer, the recipient and <i>addrFees</i> and allowance for sender are updated accordingly.

Returns true if the transfer is successfuly completed.
