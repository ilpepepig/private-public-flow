mod test;

use aztec::macros::aztec;

#[aztec]
pub contract PrivatePublic {
    // aztec library
    use aztec::{
        context::PrivateContext,
        macros::functions::{initializer, internal, private, public},
    };

    #[public]
    #[initializer]
    fn constructor() {}

    #[private]
    fn fail_in_private() {
        PrivatePublic::at(context.this_address()).fail_in_public().enqueue(&mut context);

        assert(false, "Expected failure");
    }

    #[private]
    fn check_and_push_nullifier() {
        let some_hash: Field = 1234;

        PrivatePublic::at(context.this_address()).check_nullifier_existence(some_hash).enqueue(
            &mut context,
        );

        context.push_nullifier(some_hash);
    }

    #[private]
    fn push_and_check_nullifier() {
        let some_hash: Field = 1234;

        context.push_nullifier(some_hash);

        PrivatePublic::at(context.this_address()).check_nullifier_existence(some_hash).enqueue(
            &mut context,
        );
    }

    #[public]
    #[internal]
    fn check_nullifier_existence(some_hash: Field) {
        assert(context.nullifier_exists(some_hash, context.this_address()), "Nullifier not found");
    }

    #[public]
    #[internal]
    fn fail_in_public() {
        assert(false, "Unexpected failure");
    }
}
