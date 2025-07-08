use crate::{DebugContract, test::utils};

#[test(should_fail_with = "Expected failure")] // but fails with "Unexpected failure"
unconstrained fn private_public_assertion_order() {
    let (env, contract_address, owner, recipient) = utils::setup_contract(false);

    DebugContract::at(contract_address).fail_in_private().call(&mut env.private());
}

#[test] // Does not fail because the public call is enqueued after the nullifier was pushed
unconstrained fn check_nullifier_existence() {
    let (env, contract_address, owner, recipient) = utils::setup_contract(false);

    DebugContract::at(contract_address).push_and_check_nullifier().call(&mut env.private());
}

#[test] // but fails with "Nullifier not found"
unconstrained fn check_nullifier_existence_inverted_order() {
    let (env, contract_address, owner, recipient) = utils::setup_contract(false);

    DebugContract::at(contract_address).check_and_push_nullifier().call(&mut env.private());
}
