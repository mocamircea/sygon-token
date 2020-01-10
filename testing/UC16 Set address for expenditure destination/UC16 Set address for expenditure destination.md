# UC16 Set address for expenditure destination
## <i>setAddressForExpDest</i>

The creator modifies the address for a defined expenditure destination.

### Preconditions
Setting an address of expenditure destination is performed exclusively by the Creator, 
the provided address can not be the Creator, only implicit destinations can be modified.

### Steps
Assign the provided address to the requested expenditure destination in <i>expDestinations</i>.

### Postconditions
The expenditure destination has the newly provided address.

Emit event <i>ChangeEDAddress</i>.

Returns true if the provided address was successfully assigned.
