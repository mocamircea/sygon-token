# UC3 Transfer as token release
## <i>transferAsTokenRelease</i>

The Creator releases tokens exclusively with this method. There is no other way to release tokens from the Creator's balance.

In a token release transfer, the Creator transfers an amount <i>nAmount</i> to a contributor for a specific project and installment.

## Preconditions
Input parameters: address of the contributor, amount to transfer, project ID and installment ID.

The remaining releasable supply must cover the cumulated amounts that are transferred to all release destinations in the current release.

<b>Transfer restrictions</b>: the amount is strictly positive, balance of Creator fully covers the entire amount (for all release destinations), can not transfer to Creator, can not transfer to a splitter, address required in the transfer must be different from all release destinations [PRO, OPR, ED3, ED4], can not trasfer to 0x0, can not trasfer to <i>addrFees</i>, the amount is not burned.

## Steps
For any amount transferred to a DEV destination, the corresponding amounts for all other 4 release destinations [PRO, OPR, ED3, ED4] are automatically calculated using <i>ReleaseDestSetting.nWeight</i>. Amounts for all release destinations must be successfully transferred atomically.

A fee is collected at <i>addrFees</i> from each particular transfer, according to the <i>feeSettings</i>.

## Postconditions
After the transfer is completed, all balances have the correct amounts: - 1) the transferred amounts are calculated based on <i>ReleaseDestSetting.nWeight</i> for destinations [PRO, OPR, ED3, ED4] and 2) the total sum of the amounts credited to the release destinations + total collected fees = the amount debited from Creator's balance.

The total fee collected at <i>addrFees</i> = total sum of fees for all transfers.

<i>TransferTokenRelease</i> and <i>Transfer</i> events are emitted for each particular transfer (from Creator's balance to the release destinations).

<i>transferAsTokenRelease</i> returns true if all transfers are successfuly completed.





