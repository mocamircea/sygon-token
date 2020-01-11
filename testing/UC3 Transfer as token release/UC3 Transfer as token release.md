# UC3 Transfer as token release
## <i>transferAsTokenRelease</i>

The Creator releases tokens exclusively with this method. There is no other way to release tokens from the Creator's balance.

In a token release transfer, the Creator transfers an amount <i>nAmount</i> to a contributor for a specific project and installment.

## Preconditions
Input parameters:

1. Address of the contributor
2. Amount to transfer
3. Project ID
4. Installment ID.

<b>Transfer restrictions</b>: 
1. The function can be called by Creator only
2. The contributor address is:
    1. Not Creator
    2. None of the release destinations [PRO, OPR, ED3, ED4]
    3. Not <i>addrFees</i>
    4. Not <i>addrAliasTarget</i>
    5. Not a splitter
    6. Not 0x0
3. The amount to transfer is strictly positive
4. Balance of Creator fully covers the entire amount required by the current release
5. The amount is not burned.

## Steps
For any amount transferred to a DEV destination, the corresponding amounts for all 4 implicit release destinations [PRO, OPR, ED3, ED4] are automatically calculated using <i>ReleaseDestSetting.nWeight</i>.

A fee is collected at <i>addrFees</i> from each particular transfer, according to the <i>feeSettings</i>.

## Postconditions
After the transfer is completed, all balances have the correct amounts: - 1) the transferred amounts are calculated based on <i>ReleaseDestSetting.nWeight</i> for destinations [PRO, OPR, ED3, ED4] and 2) the total sum of the amounts credited to the release destinations + total collected fees = the amount debited from Creator's balance.

The total fee collected at <i>addrFees</i> = total sum of fees for all transfers.

<i>TransferTokenRelease</i> and <i>Transfer</i> events are emitted for each particular transfer (from Creator's balance to the release destinations).

<i>transferAsTokenRelease</i> returns true if all transfers are successfuly completed.





