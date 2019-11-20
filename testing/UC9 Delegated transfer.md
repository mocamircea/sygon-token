# UC9 Delegated transfer (transferFrom)

## Preconditions
The transfer can not be performed by the Creator, can not be made from Creator's balance, 
Creator can not be recipient, transferred amount can not be burned, the transferred amount is strictly positive, 
the transfer can not be made from <i>addrAliasTarget</i> or <i>addrFees</i>.
The balance of the source of transfer must cover the transferred amount.
The allowance for the sender must cover the transferred amount.

## Steps
The transfer is operated by delegating to <i>transferFrom</i> and if this is successful, allowance for the sender is reduced with the 
tranferred amount.

Returns true if transfer is successfuly completed.

## Postconditions
Balance of transfer source, recipient and <i>addrFees</i> and allowance for sender are updated with the transferred amount.
