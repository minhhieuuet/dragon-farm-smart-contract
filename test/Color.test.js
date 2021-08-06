const { assert } = require("chai");

const Color = artifacts.require("./Color.sol");

require("chai").use(require("chai-as-promised")).should();

contract("Color", (accounts) => {
  let contract;

  before(async () => {
    contract = await Color.deployed();
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
      assert.equal(name, "Color");
    });

    it("has a symbol", async () => {
      const symbol = await contract.symbol();
      assert.equal(symbol, "COLOR");
    });
  });

  describe("minting", async () => {
    // it("creates new token", async () => {
    //   const result = await contract.mint("#FFFFFF");
    //   const totalSupply = await contract.totalSupply();
    //   //Success
    //   assert.equal(totalSupply, 1);
    //   const event = result.logs[0].args;
    //   assert.equal(event.tokenId.toNumber(), 1, "id is correct");
    //   assert.equal(
    //     event.from,
    //     "0x0000000000000000000000000000000000000000",
    //     "from is correct"
    //   );
    //   assert.equal(event.to, accounts[0], "to is correct");

    //   //Failure
    //   await contract.mint("#FFFFFF").should.be.rejected;
    // });
  });
  describe("indexing", async () => {
    it("lists colors", async () => {
      //Mint 3 tokens
      await contract.mint("#FFFFFFA");
      await contract.mint("#538EEA")
      await contract.mint("#000000")
      await contract.mint("#000000A")
      const [totalSupply] = (await contract.totalSupply()).words
      let color
      let result = []
      for(var i = 1; i <= totalSupply; i++) {
        color = await contract.colors(i-1)
        result.push(color)
      }
  
      let expected = ["#FFFFFFA", "#538EEA", "#000000", "#000000A"]
      assert.equal(result.join(""), expected.join(""), "perfect balance")
    });
  });
});
