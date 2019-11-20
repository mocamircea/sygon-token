# UC4 Transfer

Transfers an amount of tokens to a given address.

## Preconditions
The transfer is restricted: function is not callable by Creator, the amount is not transferred to Creator, the amount is not burned, the amount is strictly positive, the destination is not the alias target, the transfer frp, <i>addrFees</i> is forbidden, the balance of the sender is covering the transferred amount.

## Steps
Delegate to <b>UC5 conditionalTransfer</b>

Returns true if transfer is successful.

## Postconditions
Balances of sender, recipient and <i>addrFees</i> are correctly updated.
