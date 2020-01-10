# UC29 Validate splitter
### <i>splitWeightsValid</i>

Any user can validate a given splitter by checking the weights of its split destinations. The weight of the primary destination must be in the (0,99] range and the sum of the 
weights for entries 1-6 (secondary and all managed entries) must total 100.

### Preconditions

### Steps
Verify conditions for primary split destination and if valid, 

Calculate the sum of weights for entries 1-6. Verify if they total 100.

### Postconditions
Returns true if all validation conditions are met for all entries of the provided splitter.
