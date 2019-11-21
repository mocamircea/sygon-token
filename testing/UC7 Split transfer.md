# UC7 Split transfer (internal) - <i>transferSplit</i>
A split transfer is not performed directly by the user, but throught delegation from <i>transfer</i>, 
when the recipient address is detected to be a splitter.

## Preconditions

## Steps
Firstly the amount is calculated for the primary destination of the splitter (using the weight of the first entry in the splitter).

The amount is transfered to the split destination address by delegating to <i>executeTransfer</i>.

Amounts for the other splitter entries (entries 1-6 = secondary destination and the 5 managed destinations) are calculated and transferred by delegating to <i>executeTransfer</i>.

## Postconditions
If transfer is successful, balances of sender and entries defined in splitter have updated values.

Returns true if transfers are successfuly completed.
