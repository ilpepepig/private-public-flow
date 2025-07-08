import {
  DebugContractContract,
  DebugContractContractArtifact,
} from "../artifacts/DebugContract.js";
import {
  AccountWallet,
  CompleteAddress,
  PXE,
  AccountWalletWithSecretKey,
} from "@aztec/aztec.js";
import { getInitialTestAccountsWallets } from "@aztec/accounts/testing";
import { deployDebugContract, setupSandbox } from "./utils.js";

describe("DebugContract Contract", () => {
  let pxe: PXE;
  let wallets: AccountWalletWithSecretKey[] = [];
  let accounts: CompleteAddress[] = [];

  let alice: AccountWallet;
  let bob: AccountWallet;
  let carl: AccountWallet;

  let debug_contract: DebugContractContract;

  beforeAll(async () => {
    pxe = await setupSandbox();

    wallets = await getInitialTestAccountsWallets(pxe);
    accounts = wallets.map((w) => w.getCompleteAddress());

    alice = wallets[0];
    bob = wallets[1];
    carl = wallets[2];
  });

  beforeEach(async () => {
    debug_contract = await deployDebugContract(alice);
  });

  it("private_public_assertion_order", async () => {
    await expect(debug_contract.methods.fail_in_private().send().wait())
      .rejects.toThrow
      //Expected failure,
      ();
  });

  it("check_nullifier_existence", async () => {
    await debug_contract.methods.push_and_check_nullifier().send().wait();
  });

  it("check_nullifier_existence_inverted_order", async () => {
    await debug_contract.methods.check_and_push_nullifier().send().wait();
  });
});
