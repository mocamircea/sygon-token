# Transfer from alias target (<i>transferFromAliasTarget</i>)

The alias target receives all amounts transferred to aliases. This amount must be shared among the contributors of the SYGON technology, that are registered as split destinations in splitters.

## Preconditions
Transferred amount is strictly positive, the transfer can be performed only by the owner of the <i>addrAliasTarget</i> address or a delegated user,
the recipient of the transfer is a splitter, the balance of the <i>addrAliasTarget</i> covers the transferred amount.

## Steps
If transfer is performed directly by the owner of <i>addrAliasTarget</i> address then the transfer is operated by delegating to <i>executeTransfer</i>.

Else, if the transfer is performed by a delegated user, the allowance covers the transferred amount, then operate the transfer by 
delegating to <i>executeTransfer</i> and update allowance for delegated user.

Return true if the transfer is completed successfully.

## Postconditions
Balances of <i>addrAliasTarget</i>, recipient and <i>addrFees</i> and allowance for sender are correctly updated.
