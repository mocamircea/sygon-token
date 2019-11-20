# UC16 Set address for expenditure destination
## <i>setAddressForExpDest</i>

### Preconditions
Setting an address of expenditure destination is performed exclusively by the Creator, 
the provided address can not be the Creator, only implicit destinations can be modified.

### Steps
Assign the provided address to the requested expenditure destination in <i>expDestinations</i>.
Returns true if mutation is successful.

### Postconditions
The expenditure destination has the provided address.
