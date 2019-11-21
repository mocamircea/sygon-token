# UC19 Change Fees Address
Change the address that collects fees.

### Preconditions
Restrictions: sender must be the actual owner of <i>addrFees</i>, the balance of <i>addrFees</i> must 
be 0.

### Steps
Emptying the balance of <i>addrFees</i> is delegated to <i>distributeAndBurnFee()</i>.

Assign new address.

Emit <i>ChangeFeesAddress</i>

### Postconditions
Returns success status of the change operation.
