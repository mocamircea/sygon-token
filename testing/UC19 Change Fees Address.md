# UC19 Change Fees Address
## <i>changeFeesAddr</i>

The owner of the <i>addrFees</i> changes the address that collects fees.

### Preconditions
Restrictions: sender must be the actual owner of <i>addrFees</i>, the balance of <i>addrFees</i> must 
be 0. When this value >0, the value must be transferred to a splitter.

### Steps
Emptying the balance of <i>addrFees</i> by delegating to <i>distributeAndBurnFee()</i>.

Assign new address to <i>addrFees</i>.

Emit <i>ChangeFeesAddress</i>

### Postconditions
Returns true if the assignment is successfuly performed.
