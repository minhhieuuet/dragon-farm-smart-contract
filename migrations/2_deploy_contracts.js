
const DragonFarmCore = artifacts.require("DragonFarmCore");
const DragonSoul = artifacts.require("DragonSoul");
module.exports = function (deployer) {
  deployer.deploy(DragonSoul);
};
