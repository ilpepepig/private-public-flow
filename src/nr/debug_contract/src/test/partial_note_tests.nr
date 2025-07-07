use crate::{DebugContract, test::utils};

#[test]
unconstrained fn partial_note_test_succeeds() {
    let (env, contract_address, owner, recipient) = utils::setup_contract(false);

    env.impersonate(owner);
    DebugContract::at(contract_address).f_succeeds(owner, recipient).call(&mut env.private());
}

#[test]
unconstrained fn partial_note_test_fails() {
    let (env, contract_address, owner, recipient) = utils::setup_contract(false);

    env.impersonate(owner);
    DebugContract::at(contract_address).f_fails(owner, recipient).call(&mut env.private());
}
