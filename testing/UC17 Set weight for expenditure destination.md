# UC17 Set weight for expenditure destination
## <i>setWeightForExpDest</i>

### Preconditions
Setting the weight of an expenditure destination is performed exclusively by the Creator, 
the provided weight is strictly positive, only implicit destinations can be modified.

### Steps
Assign the provided weight to the requested expenditure destination in <i>expDestinations</i>.
Returns true if mutation is successful.

### Postconditions
The expenditure destination has the provided weight.
Emit event <i>ChangeEDWeight</i>.
