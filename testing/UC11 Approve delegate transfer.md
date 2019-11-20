# UC11 Approve delegated transfer

<i>approve</i> allows the sender to add an address to transfer amounts from its balance. The allowance is limited as maximum to the current balance of the sender.

## Preconditions
The sender is not the Creator, the allowed address is not Creator, the sender is different from allowed address.

## Steps
A new entry for the sender with allowance for the address and the specified amount is added.

## Postconditions
Event <i>ApproveDelegateSpender</i> is emitted.

The allowance for the allowed address is updated with the new amount.
