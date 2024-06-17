use aiken/hash.{Blake2b_224, Hash}
use aiken/list.{has}
use aiken/transaction.{ScriptContext}
use aiken/transaction/credential.{VerificationKey}
use aiken/transaction/value.{AssetName, PolicyId}

type VerificationKeyHash = Hash<Blake2b_224, VerificationKey>

type TokenAmount {
  // The policy ID of a token to be swapped:
  policy_id: PolicyId,
  // The asset name of a token to be swapped
  // (optional to allow collection offers):
  asset_name: Option<AssetName>,
  // The amount of a token to be swapped:
  quantity: Int,
}

type Datum {
  // ID of the swap offer
  // * required to be unique in transactions
  // * up to frontends to decide what to use here (POSIX time, counter, …):
  id: Int,
  // The owner of this swap offer:
  owner: VerificationKeyHash,
  // What the owner offers:
  offer: TokenAmount,
  // What of the offered quantity has already been swapped:
  swapped: Int,
  // What the owner wants to have for it:
  request: TokenAmount,
}

type Action {
  // The owner can close the offer at any time:
  Close
  // Everybody can swap (part of) the offer:
  Swap {
    given: Int,
    taken: Int,
  }
}

validator {
  fn swap(datum: Datum, redeemer: Action, ctx: ScriptContext) -> Bool {
    when redeemer is {
      Close ->
        // Only requirement is that the owner has signed:
        has(ctx.transaction.extra_signatories, datum.owner)
      Swap(given, taken) ->
        and {
          // The main requirement for swaps:
          // What is given is at least the defined price
          // (requested/offered) times what is taken.
          given * datum.offer.quantity >=
            taken * datum.request.quantity,
          todo
          // Check that there is exactly one input
          //                 and exactly one output
          //            for the given ID
          // Check that datum.swapped is updated by swap.taken
          //            and otherwise preserved
          // Check that for all assets not in the swap the amount
          //            in the output is equal
          // Find number of offered and requested tokens
          //                in input and output
          //                (sum of several if asset_name is None,
          //                 0 if not in Value)
          // Check taken tokens as:
          //             offered in input - offered in output
          // Check given tokens as:
          //            requested in output - requested in input
        }
    }
  }
}
