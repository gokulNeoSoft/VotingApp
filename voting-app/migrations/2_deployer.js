var MyContract = artifacts.require("election");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
};