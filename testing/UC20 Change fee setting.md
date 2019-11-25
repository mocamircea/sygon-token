# UC20 Change fee setting
## <i>changeFeeSetting</i>

The fee owner modifies the values of the fields (like ceiling and factor and decimals) for one of the three existent fee settings.

A particular fee setting is identified with its ID (field <i>nFeeID</i>). Allowed IDs are: 0, 1, 2;

### Preconditions
Restrictions: only the owner of <i>addrFees</i> can change the fields of fee settings, the setting ID value is in {0,1,2}, 
the range ceiling is strictly positive and striclty smaller than the circulating supply.

### Steps
Assign new values to setting: range ceiling, factor and its decimals.

### Postconditions
Returns true if the change operation is successfully completed.
