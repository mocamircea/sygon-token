# UC7 Split transfer (internal)
## <i>transferSplit</i>

A split transfer is not performed directly by the user, but throught delegation from the <i>transfer</i> function, 
when the recipient address is registered as splitter.

## Preconditions
None assessed by callers.

## Steps
Firstly the amount is calculated for the primary destination of the splitter (using the weight of the first entry in the splitter).

The amount is transfered to the split destination address by delegating to <i>executeTransfer</i>.

Amounts for the other splitter entries (entries 1-6, secondary destination and the 5 managed destinations) are calculated and further transferred by delegating to <i>executeTransfer</i>.

## Postconditions
If transfer is successful, balances of sender and all active entries of the splitter are updated with the transferred amounts.

Returns true if transfers are successfuly completed.
