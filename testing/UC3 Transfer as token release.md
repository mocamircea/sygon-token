# UC3 Transfer as token release

Tokens are released from the <i>balances[addrCreator]</i> by this method exclusively. There is no other way to release tokens.

A token release is: the Creator transfers an amount X to a project developer (to address with "DEV" destination) at choice.

## Preconditions:
Tokens can be released until the remaining releasable supply is 0 (<i>balances[addrCreator]</i> is 0).

<b>Transfer restrictions</b>: the amount is strictly positive, balance of Creator fully covers the entire transfer (to all release destinations), not to Creator, not to a splitter, not to release destinations [PRO, OPR, ED3, ED4], not to 0x0, not to <i>addrFees</i>, can not be burned.

## Steps
For any amount transferred to a "DEV" destination, the corresponding amounts for all other 4 release destinations [PRO, OPR, ED3, ED4] are automatically calculated using <i>ExpDestSetting.nWeight</i>. Amounts for all release destinations must be successfully transferred atomically (all or none).

A fee is applied to each particular transfer, according to the <i>feeSettings</i>.

<i>transferAsTokenRelease</i> returns true if transfers to all release destinations are successfuly completed.

## Postconditions:
After the transfer is completed, all balances have the correct amounts: - 1) transferred amounts are calculated based on <i>ExpDestSetting.nWeight</i> for destinations [PRO, OPR, ED3, ED4] and 2) the sum of the amounts credited to the release destinations = the amount debited from Creator.

The total fee collected at <i>addrFees</i> is correct (sum of all applied fees).

<i>Transfer</i> and <i>TransferTokenRelease</i> events are emitted for each particular transfer (from Creator to the release destinations).





