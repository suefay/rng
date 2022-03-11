// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title Interface for Random Number Generator
 */
interface RNGInterface {
  /**
   * @notice Triggered when a new request for a random number is initiated
   * @param requestId The ID of the request
   * @param sender The address of the request initiator
   */
  event RandomNumberRequested(uint32 indexed requestId, address indexed sender);

  /**
   * @notice Triggered when an existing request for a random number is finished
   * @param requestId The ID of the request
   * @param randomNumber The random number corresponding to the request ID
   */
  event RandomNumberCompleted(uint32 indexed requestId, uint256 randomNumber);

  /**
   * @notice Initiate a request for a random number
   * @return requestId The ID of the request
   */
  function requestRandomNumber() external returns (uint32 requestId);

  /**
   * @notice Check whether the specified request for the random number is finished
   * @param requestId The ID of the request
   * @return completed True if the request is finished, false otherwise
   */
  function isRequestCompleted(uint32 requestId) external view returns (bool completed);

  /**
   * @notice Retrieve the random number by the request ID
   * @param requestId The ID of the request
   * @return randomNumber The random number
   */
  function getRandomNumber(uint32 requestId) external returns (uint256 randomNumber);

   /**
   * @notice Get the last request ID
   * @return requestId The last request ID
   */
  function getLastRequestId() external view returns (uint32 requestId);
}