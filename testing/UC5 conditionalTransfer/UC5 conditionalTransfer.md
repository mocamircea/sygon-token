# UC5 conditionalTransfer (internal)
## <i>conditionalTransfer</i>

Checks if recipient is splitter or alias and delegates to <i>executeTransfer</i>

## Preconditions
None, high-level restrictions are assessed by callers.

## Steps
If recipient is not alias or splitter, delegate to <i>executeTransfer</i>.

If recipient is splitter and splitter weights are correctly defined,
1) transfer amount from sender to recipient by delegating to <i>executeTransfer</i> then 2) transfer amount from recipient to splitter by 
delegating to <i>transferSplit</i>.

If recipient is alias, transfer the amount from sender to the alias target <i>addrAliasTarget</i> by delegating to <i>executeTransfer</i>.

## Postconditions
Returns true if the transfer is successfuly completed.

