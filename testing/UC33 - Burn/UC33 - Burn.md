# UC33 Burn
Burn amount of token from sender's balance.

### Preconditions
Restrictions: operation is forbidden for Creator and the total burned amount must be < max total burnable amount, balance 
of sender must cover the amount to burn.

### Steps
Update balance of sender by debiting the burned amount.

Emit <i>Burn</i>.

If max total burnable is reached, deactivate the burn mechanism (so that no further burn is possible).

### Postconditions
Returns true if the burn operation was successfully completed.
