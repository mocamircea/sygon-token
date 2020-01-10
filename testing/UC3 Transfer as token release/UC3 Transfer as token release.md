# UC3 Transfer as token release
## <i>transferAsTokenRelease</i>

Tokens are released from the <i>balances[addrCreator]</i> by Creator, exclusively with this method. There is no other way to release tokens from Creator's balance.

In a token release transfer, the Creator transfers an amount <i>nAmount</i> to a contributor (providing an address and the "DEV" destination).

## Preconditions
The remaining releasable supply covers the cumulated amounts to be transferred to all release destinations.

<b>Transfer restrictions</b>: the amount is strictly positive, balance of Creator fully covers the entire amount (for all release destinations), can not transfer to Creator, can not transfer to a splitter, address required in the transfer must be different from all release destinations [PRO, OPR, ED3, ED4], can not trasfer to 0x0, can not trasfer to <i>addrFees</i>, the amount can not be burned.

## Steps
For any amount transferred to a DEV destination, the corresponding amounts for all other 4 release destinations [PRO, OPR, ED3, ED4] are automatically calculated using <i>ReleaseDestSetting.nWeight</i>. Amounts for all release destinations must be successfully transferred atomically.

A fee is collected at <i>addrFees</i> from each particular transfer, according to the <i>feeSettings</i>.

## Postconditions
After the transfer is completed, all balances have the correct amounts: - 1) transferred amounts are calculated based on <i>ReleaseDestSetting.nWeight</i> for destinations [PRO, OPR, ED3, ED4] and 2) the total sum of the amounts credited to the release destinations + total collected fees = the amount debited from Creator's balance.

The total fee collected at <i>addrFees</i> is correct - sum of fees for all transfers.

<i>Transfer</i> and <i>TransferTokenRelease</i> events are emitted for each particular transfer (from Creator to the release destinations).

<i>transferAsTokenRelease</i> returns true if transfers to all release destinations are successfuly completed.





