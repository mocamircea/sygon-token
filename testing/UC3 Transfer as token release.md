# UC3 Transfer as token release

Tokens are released from the <i>balances[addrCreator]</i> by this method exclusively. There is no other way to release tokens.

Tokens can be released until the remaining releasable supply is 0 (<i>balances[addrCreator]</i> is 0).

<b>Transfer restrictions</b>: the amount is strictly positive, not to Creator, not to a splitter, not to release destinations [PRO, OPR, ED3, ED4], not to 0x0, not to <i>addrFees</i>, can not be directly burned.

A token release is: the Creator transfers an amount X to a project developer (to address with "DEV" destination) at choice.

For any transferred amount X, the corresponding amounts for all other 4 destinations are automatically computed. Amounts for all release destinations must be successfully transferred.

<i>Transfer</i> and <i>TransferTokenRelease</i> events are emitted for each particular transfer (from Creator to the release destinations).

After the transfer is completed, all balances have the correct amounts: - 1) transferred amounts are calculated based on <i>ExpDestSetting.nWeight</i> for destinations [PRO,OPR,ED3,ED4] and 2) the sum of the amounts credited to the release destinations = the amount debited from Creator.

A fee is applied to each particular transfer, according to the <i>feeSettings</i>.

The total fee collected at <i>addrFees</i> is correct (sum of all applied fees).





