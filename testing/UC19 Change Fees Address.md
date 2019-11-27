# UC19 Change Fees Address
## <i>changeFeesAddr</i>

The owner of the <i>addrFees</i> changes the address that collects fees.

### Preconditions
Restrictions: the sender must be the actual owner of <i>addrFees</i>, the balance of <i>addrFees</i> must 
be 0. When this value is non-zero, the respective amount must be transferred to a splitter.

### Steps
Emptying the balance of <i>addrFees</i> by delegating to <i>distributeAndBurnFee</i>.

Assign new address to <i>addrFees</i>.

Emit <i>ChangeFeesAddress</i>

### Postconditions
Returns true if the assignment of the provided address is performed successfully.
