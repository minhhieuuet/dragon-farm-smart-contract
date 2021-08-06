
const DragonFarmCore = artifacts.require("DragonFarmCore");
const DragonFarmToken = artifacts.require("DragonFarmToken");
module.exports = function (deployer) {
  deployer.deploy(DragonFarmToken);
  deployer.deploy(DragonFarmCore);
};
