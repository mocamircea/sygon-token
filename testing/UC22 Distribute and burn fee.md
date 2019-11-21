# UC22 Distribute and burn fee
The objective is to distribute the fees collected at <i>addrFees</i> by transferring a fraction to 
the operating entity and burning the rest.

### Preconditions
Restrictions: only the owner of <i>addrFees</i> can distribute and burn fees. Collected fees >= 100.

### Steps
Calculate the amount to burn. Burn the amount.

Transfer the reminder to "OPR" expenditure destination.

### Postconditions
Returns true if the transfer and burn are completed successfully.
