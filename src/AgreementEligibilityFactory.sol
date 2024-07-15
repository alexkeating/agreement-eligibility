// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { AgreementEligibility } from "src/AgreementEligibility.sol";
import { L2ContractHelper } from "./lib/L2ContractHelper.sol";

contract AgreementEligibilityFactory {
  string public constant VERSION = "0.6.0-zksync";
  /// @dev Bytecode hash can be found in zkout/AgreementEligibility.sol/AgreementEligibility.json under the hash key.
  bytes32 constant BYTECODE_HASH = 0x01000335c26aeb826dba8811279c2f834a3856a35e73dcd86bbec6ff7cc1075f;

  event ModuleDeployed(
    address implementation, address instance, uint256 hatId, bytes otherImmutableArgs, bytes initData, uint256 saltNonce
  );

  function deployAgreementEligibility(uint256 _hatId, address _hat, bytes calldata _initData, uint256 _saltNonce)
    external
    returns (address)
  {
    bytes memory saltArgs = abi.encodePacked(VERSION, _hatId, _hat, _initData);
    bytes32 salt = _calculateSalt(saltArgs, _saltNonce);
    AgreementEligibility instance = new AgreementEligibility{ salt: salt }(VERSION, _hat, _hatId);
    instance.setUp(_initData);
    emit ModuleDeployed(
      address(instance), address(instance), _hatId, abi.encodePacked(_hat, _initData), _initData, _saltNonce
    );
    return address(instance);
  }

  function _calculateSalt(bytes memory _args, uint256 _saltNonce) internal view returns (bytes32) {
    return keccak256(abi.encodePacked(_args, block.chainid, _saltNonce));
  }

  function getAddress(uint256 _hatId, address _hat, bytes calldata _initData, uint256 _saltNonce)
    external
    view
    returns (address addr)
  {
    bytes memory saltArgs = abi.encodePacked(VERSION, _hatId, _hat, _initData);
    bytes32 salt = _calculateSalt(saltArgs, _saltNonce);
    addr = L2ContractHelper.computeCreate2Address(
      address(this), salt, BYTECODE_HASH, keccak256(abi.encode(VERSION, _hat, _hatId))
    );
  }
}
