# Transfer from alias target
## <i>transferFromAliasTarget</i>

The alias target address receives all amounts transferred to aliases. This amount is further distributed to the contributors of the SYGON technology. Contributors are registered as split destinations in splitters.

### Preconditions
Restrictions: the transferred amount is strictly positive, the transfer can be performed only by the owner of the <i>addrAliasTarget</i> address or a delegated user,
the recipient of the transfer is mandatory a splitter, the balance of the <i>addrAliasTarget</i> covers the transferred amount.

### Steps
If transfer is performed directly by the owner of <i>addrAliasTarget</i> then the transfer is operated by delegating to <i>executeTransfer</i>.

Else, if the transfer is performed by a delegated spender, the allowance covers the transferred amount, then operate the transfer by 
delegating to <i>executeTransfer</i>. Update allowance for delegated user with the transferred amount.

### Postconditions
Balances of <i>addrAliasTarget</i>, recipient and <i>addrFees</i> and allowance for sender are correctly updated.

Returns true if the transfer from alias target is completed successfully.
