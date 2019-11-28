# UC21 Change burn from fee quota
## <i>changeBurnFromFeeQuota</i>

Change the quota of burn from the total collected fees.

### Preconditions
Restrictions: only the owner of <i>addrFees</i> can change the value of quota, the quota is in [20,100] range.

### Steps
Assign the provided value for quota.

Emit <i>ChangeBurnFromFeeQuota</i>.

### Postconditions
Returns true if assigning the new value for quota is successfuly completed.
