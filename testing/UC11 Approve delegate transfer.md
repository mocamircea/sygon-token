# UC11 Approve delegated transfer
## <i>approve</i>

Allows the sender to register an address with permission to transfer amounts from their balance up to a specified threshold. The allowance is limited to the actual value of the sender's balance.

## Preconditions
The sender is not the Creator, the allowed address is not Creator's, the sender is different from the allowed address.

## Steps
A new entry for the sender with allowance for the address and the specified amount is added.

Emit <i>ApproveDelegateSpender</i>.

## Postconditions
The allowance for the allowed address is updated with the new amount.

Returns true if approval is successfuly added.
