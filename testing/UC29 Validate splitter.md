# UC29 Validate splitter
### <i>splitWeightsValid</i>

Validate splitter by checking weights of split destinations. The weight of the primary destination must be in (0,99] and the sum of the 
weights for entries 1-6 (secondary and all managed) must be 100.

### Preconditions

### Steps
Verify conditions for primary destination and if valid, 

Calculate the sum of weights for entries 1-6.

Verify if calculated sum is 100.

### Postconditions
Returns true if validation conditions are met for all entries.
