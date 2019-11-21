# UC6 executeTransfer (internal)

## Preconditions

## Steps
Calculate fee by delegating to <i>calculateFee</i>.

Calculate net amount.

Update balances of sender and recipient with net amount.

Emit <i>Transfer</i>.

If calculated fee is > 0 then update balances of sender and <i>addrFees</i> with the calculated fee amount.

Emit <i>Transfer</i>.

## Postconditions
All balances of sender, receiver and eventually <i>addrFees</i> are updated.

