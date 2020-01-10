# UC18 Calculate fee
## <i>calculateFee</i>

Any user can calculate the fee for a given amount. This is called by <i>executeTransfer</i> to 
calculate the fee to be applied for a transfer.

### Preconditions
The amount is strictly positive.

### Steps
Find the range for the provided amount. Apply the factor, according to the respective range setting.

### Postconditions
Returns the calculated fee for the provided amount.
