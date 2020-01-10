# UC24 Change alias target
## <i>changeAliasTarget</i>

The Alias Manager changes the address of alias target.

### Preconditions
Restrictions: only the creator can change the alias target address, the provided address: can not be Creator's, can not be an alias, can not be any of the defined expenditure destinations.

### Steps
Assign the provided address to <i>addrAliasTarget</i>.

### Postconditions
Returns true if assigning the provided address to <i>addrAliasTarget</i> is successfully completed.
