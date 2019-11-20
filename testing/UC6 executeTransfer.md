# UC6 executeTransfer (internal)

## Preconditions

## Steps
Calculate fee by delegating to <i>calculateFee</i>.

Calculate net amount.

Update balances of sender and recipient with net amount.

Emit <i>Transfer</i> event.

If calculated fee >0 update balances of sender and <i>addrFees</i> with the calculated fee amount.

Emit <i>Transfer</i> event.

## Postconditions
All balances of sender, receiver and eventually <i>addrFees</i> are correctly updated.
