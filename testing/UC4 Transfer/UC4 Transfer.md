# UC4 Transfer
## <i>transfer</i>

The sender transfers an amount of tokens to a given address.

## Preconditions

#### Input parameters
1. Address of recipient
2. Amount to transfer

#### Restrictions
1. The function is not callable by Creator (to avoid circumventing the call to <i>transferAsTokenRelease</i>)
2. The destination address is not Creator
3. The amount is strictly positive
4. The sender is 
    1. Not <i>addrAliasTarget</i>
    2. Not <i>addrFees</i>
5. The amount is not burned
6. The balance of the sender is covering the transferred amount.

## Steps
Delegate to <b>UC5 conditionalTransfer</b>.

A fee is applied and collected from the transfer.

## Postconditions
Balances of sender, recipient and <i>addrFees</i> are correctly updated.

Returns true if the transfer is completed successfully.
