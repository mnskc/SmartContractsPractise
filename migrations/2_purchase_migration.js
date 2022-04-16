const PurchaseAgreement = artifacts.require("PurchaseAgreement");

module.exports = function (deployer) {
  deployer.deploy(PurchaseAgreement);
};
