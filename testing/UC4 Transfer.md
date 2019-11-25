# UC4 Transfer
## <i>transfer</i>

The sender transfers an amount of tokens to a given address.

## Preconditions
The transfer is restricted: function is not callable by Creator, the transfer can not be to Creator, the amount is not burned, the amount is strictly positive, the destination can not be the alias target, the transfer from <i>addrFees</i> is forbidden, the balance of the sender is covering the transferred amount.

## Steps
Delegate to <b>UC5 conditionalTransfer</b>.

A fee is applied and collected from the transfer.

## Postconditions
Balances of sender, recipient and <i>addrFees</i> are correctly updated.

Returns true if transfer is completed successfully.
