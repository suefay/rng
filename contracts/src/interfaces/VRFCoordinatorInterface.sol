// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface VRFCoordinatorInterface {
  /**
   * @notice Request randomness
   *
   * @param keyHash ID of the VRF public key against which to generate output
   * @param feePaid Amount of fee sent with request
   */
  function randomnessRequest(
    bytes32 keyHash,
    uint256 feePaid
  ) external returns (uint256 requestId);
}
