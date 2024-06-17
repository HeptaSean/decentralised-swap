# Decentralised Swaps for Cardano
The goal of this project is to provide a validator, a smart contract that
allows users to offer swaps in a decentralised way on UTxOs that they fully
control, can stake to their own stake key, can close at any time, …

Those offers can be taken up by other users directly or be matched against
each other by bots that search for arbitrage opportunities – maybe even by
swapping several different asset pairs against each other.

The idea is similar to
[Cardano-Swaps](https://github.com/fallen-icarus/cardano-swaps), but much
simpler without using the beacon machinery developed there.
I'd love to discuss if this really is a huge disadvantage in practice.

We use Aiken to implement this validator and show its usage with
`cardano-cli` in some examples.

TBC
