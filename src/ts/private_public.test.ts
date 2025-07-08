import {
  PrivatePublicContract,
  PrivatePublicContractArtifact,
} from "../artifacts/PrivatePublic.js";
import {
  AccountWallet,
  CompleteAddress,
  PXE,
  AccountWalletWithSecretKey,
} from "@aztec/aztec.js";
import { getInitialTestAccountsWallets } from "@aztec/accounts/testing";
import { deployPrivatePublic, setupSandbox } from "./utils.js";

describe("PrivatePublic Contract", () => {
  let pxe: PXE;
  let wallets: AccountWalletWithSecretKey[] = [];
  let accounts: CompleteAddress[] = [];

  let alice: AccountWallet;
  let bob: AccountWallet;
  let carl: AccountWallet;

  let private_public_contract: PrivatePublicContract;

  beforeAll(async () => {
    pxe = await setupSandbox();

    wallets = await getInitialTestAccountsWallets(pxe);
    accounts = wallets.map((w) => w.getCompleteAddress());

    alice = wallets[0];
    bob = wallets[1];
    carl = wallets[2];
  });

  beforeEach(async () => {
    private_public_contract = await deployPrivatePublic(alice);
  });

  it("private_public_assertion_order", async () => {
    await expect(
      private_public_contract.methods.fail_in_private().send().wait(),
    ).rejects.toThrow("Expected failure");
  });

  it("check_nullifier_existence", async () => {
    await private_public_contract.methods
      .push_and_check_nullifier()
      .send()
      .wait();
  });

  it("check_nullifier_existence_inverted_order", async () => {
    await private_public_contract.methods
      .check_and_push_nullifier()
      .send()
      .wait();
  });
});
