# UC3 Transfer as token release

Tokens are released from the <i>balances[addrCreator]</i> by this method exclusively. There is no other way to release tokens.

Tokens can be released until the remaining releasable supply is 0 (<i>balances[addrCreator]</i> is 0).

A token release is: the Creator transfers an amount X to a project developer (to address with "DEV" destination) at choice.

For any transferred amount X, the corresponding amounts for all other 4 destinations are automatically computed. Amounts for all release destinations must be successfully transferred.

<i>Transfer</i> event is emitted for each particular transfer (from Creator's balance to the release destinations).

After the transfer, all balances (Creator + release destinations) have the correct amounts - the sum of the credited amounts for the release destinations = the amount debited from Creator's balance.

A fee is applied to each transfer from Creator to the release destinations.

The corresponding amount collected in <i>addrFees</i> is correct (according to the applied rates).





