# UC3 Transfer as token release

The Creator transfers an amount X to an address of "DEV" destination at choice.

Tokens can be released from the <i>nInitialTotalSupply</i> by this method exclusively. There is no other way to release tokens.

Tokens can be released until <i>nInitialTotalSupply</i> is 0 (zero).

For any amount X, the corresponding amounts for all other 4 destinations are computed. Amounts for all release destinations must be successfuly transferred.

<i>Transfer</i> event is emitted for each particular transfer (from Creator balance to the release destinations).

After the transfer, all balances (Creator + release destinations) are showing the correct amounts - the sum of the additions for the release destinations = the amount debited from Creator.

A fee is applied to each transfer from Creator to release destinations.

The amount collected by <i>addrFees</i> is correct.





