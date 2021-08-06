const { assert } = require("chai");

const DragonFarmToken = artifacts.require("./DragonFarmToken.sol");

require("chai").use(require("chai-as-promised")).should();

contract("DragonFarmToken", (accounts) => {
  let contract;

  before(async () => {
    contract = await DragonFarmToken.deployed();
  });

  describe("deployment", async () => {
    it("deploys successfully", async () => {
      const address = contract.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });

    it("has a name", async () => {
      const name = await contract.name();
      assert.equal(name, "Dragon Farm Token");
    });

    it("has a symbol", async () => {
      const symbol = await contract.symbol();
      assert.equal(symbol, "DFT");
    });
  });
});
