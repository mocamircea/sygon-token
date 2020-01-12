# UC6 executeTransfer (internal)
## <i>executeTransfer</i>

## Preconditions

#### Input parameters
1. Address of sender
2. Address of recipient
3. Amount to transfer.

#### Restrictions
None, assessed by callers.

## Steps
Calculate fee by delegating to <i>calculateFee</i>.

Calculate net amount for the transfer.

Update balances of sender and recipient with net amount.

Emit <i>Transfer</i>.

If calculated fee is > 0 then update balances of sender and <i>addrFees</i> with the calculated fee amount.

Emit <i>Transfer</i>.

## Postconditions
All balances of sender, receiver and <i>addrFees</i> are updated with the transferred amounts.

