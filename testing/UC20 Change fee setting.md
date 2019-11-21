# UC20 Change fee setting
Change the fields (range ceiling and the factor - with its decimals) for one of the three existent fee settings.

A particular fee setting is identified with its ID (field <i>nFeeID</i>). Allowed IDs: 0, 1, 2;

### Preconditions
Restrictions: only the owner of <i>addrFees</i> can change fee settings, the setting id value is in {0,1,2}, 
the range ceiling is strictly positive and striclty smaller than the circulating supply.

### Steps
Assign new values to setting: range ceiling, factor and its decimals.

### Postconditions
Returns true if the change operation is successfully completed.
