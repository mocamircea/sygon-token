# Transfer from alias target
## <i>transferFromAliasTarget</i>

The alias target address collects all amounts received by aliases. Periodically, the amount contained is further distributed to the contributors of the SYGON technology. Contributors are registered as split destinations in splitters. The distribution of the collected amounts is performed as transfers from the alias target to splitters.

### Preconditions
#### Input parameters
1. Destination address
2. Amount of transfer

#### Restrictions
1. The transferred amount is strictly positive
2. The transfer can be performed only by the owner of the <i>addrAliasTarget</i> address or a delegated user
3. The destination of the transfer is mandatory a splitter
4. Balance of <i>addrAliasTarget</i> covers the amount to transfer.

### Steps
If the transfer is performed directly by the owner of <i>addrAliasTarget</i> then the transfer is operated by delegating to <i>executeTransferNoFee</i> and then to <i>transferSplit</i>.

Else, if the transfer is performed by a delegated spender and if the allowance covers the transferred amount, then operate the transfer by 
delegating to <i>executeTransfer</i> and then to <i>transferSplit</i>. Update allowance for the delegated user with the transferred amount.

### Postconditions
Balances of <i>addrAliasTarget</i>, destination, <i>addrFees</i> and if the case the allowance for delegated spender are correctly updated.

Returns true if the transfer from alias target is completed successfully.
