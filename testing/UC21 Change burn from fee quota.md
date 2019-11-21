# UC21 Change burn from fee quota
Change the quota of tokens that can be burned from collected fees.

### Preconditions
Restrictions: only the owner of <i>addrFees</i> can change the quota, the quota is in [20,100] range.

### Steps
Assign new quota value.

Emit <i>ChangeBurnFromFeeQuota</i>.

### Postconditions
Returns true if the change operation is successfuly completed.
