mod test;

use aztec::macros::aztec;

#[aztec]
pub contract DebugContract {
    // aztec library
    use aztec::{
        context::PrivateContext,
        macros::{functions::{initializer, internal, private, public}, storage::storage},
        prelude::{AztecAddress, Map, PrivateSet},
    };
    // note library
    use uint_note::uint_note::{PartialUintNote, UintNote};

    #[storage]
    struct Storage<Context> {
        private_balances: Map<AztecAddress, PrivateSet<UintNote, Context>, Context>,
    }

    #[public]
    #[initializer]
    fn constructor() {}

    #[private]
    fn f_succeeds(from: AztecAddress, to: AztecAddress) {
        let completer = context.this_address();
        let partial_note: PartialUintNote = UintNote::partial(
            to,
            storage.private_balances.at(to).storage_slot,
            &mut context,
            to,
            from,
            completer,
        );

        let some_hash: Field = 1234;
        context.push_nullifier(some_hash);

        DebugContract::at(context.this_address())
            .complete_partial_note(partial_note.commitment)
            .enqueue(&mut context);
    }

    #[private]
    fn f_fails(from: AztecAddress, to: AztecAddress) {
        let some_hash: Field = 1234;
        context.push_nullifier(some_hash);

        let completer = context.this_address();
        let partial_note: PartialUintNote = UintNote::partial(
            to,
            storage.private_balances.at(to).storage_slot,
            &mut context,
            to,
            from,
            completer,
        );

        DebugContract::at(context.this_address())
            .complete_partial_note(partial_note.commitment)
            .enqueue(&mut context);
    }

    #[public]
    #[internal]
    fn complete_partial_note(commitment: Field) {
        let completer = context.this_address();
        PartialUintNote { commitment }.complete(&mut context, completer, 1);
    }
}
