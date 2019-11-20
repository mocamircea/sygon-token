# UC5 conditionalTransfer

Checks if recipient is splitter or alias and delegates to <i>executeTransfer</i>

## Preconditions

## Steps
If recipient is not an alias or splitter, delegate to <i>executeTransfer</i>

If recipient is splitter and splitter weights are correctly defined,
1) transfer amount from sendter to recipient by delegating to <i>executeTransfer</i> then 2) transfer amount from recipient to splitter by 
delegating to <i>transferSplit</i>.

If recipient is alias, transfer amount from sender to the alias target <i>addrAliasTarget</i> by delegating to <i>executeTransfer</i>.

Returns true if transfer is successfuly performed.

## Postconditions



