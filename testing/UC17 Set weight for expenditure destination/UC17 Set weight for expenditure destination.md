# UC17 Set weight for expenditure destination
## <i>setWeightForExpDest</i>

The Creator modifies the weight for a defined expenditure destination.

### Preconditions
Setting the weight of an expenditure destination is performed exclusively by the Creator, 
the provided weight value is strictly positive, only implicit destinations can be modified.

### Steps
Assign the provided weight value to the requested expenditure destination in <i>expDestinations</i>.

### Postconditions
The affected expenditure destination has the newly provided weight value.

Emit event <i>ChangeEDWeight</i>.

Returns true if the provided weight value is successfully assigned in the specified expenditure destination.
