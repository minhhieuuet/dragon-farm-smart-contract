
const Kitty = artifacts.require("KittyCore");

module.exports = function (deployer) {
  deployer.deploy(Kitty);
};
