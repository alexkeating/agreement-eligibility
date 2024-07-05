// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test, console2, Vm } from "forge-std/Test.sol";
import { AgreementEligibility } from "../src/AgreementEligibility.sol";
import { AgreementEligibilityFactory } from "../src/AgreementEligibilityFactory.sol";

contract TestMultiClaimsHatterFactory is Test {
  AgreementEligibilityFactory factory;

  function setUp() public {
    factory = new AgreementEligibilityFactory();
  }

  function testFuzz_deployAgreementEligibilty(uint256 _hatId, address _hat, uint256 _saltNonce) public {
    address instance = factory.deployAgreementEligibility(_hatId, _hat, "", _saltNonce);
    address expectedAddress = factory.getAddress(_hatId, _hat, "", _saltNonce);
    assertEq(instance, expectedAddress);
  }

  function testFuzz_deployAgreementEligibiltyTwice(uint256 _hatId, address _hat, uint256 _saltNonce) public {
    factory.deployAgreementEligibility(_hatId, _hat, "", _saltNonce);
    vm.expectRevert(bytes("Code hash is non-zero"));
    factory.deployAgreementEligibility(_hatId, _hat, "", _saltNonce);
  }
}
