// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/RNGInterface.sol";
import "./interfaces/VRFCoordinatorInterface.sol";
import "./utils/Ownable.sol";

import "./VRFConsumerBase.sol";

contract RNGVRF is RNGInterface, VRFConsumerBase, Ownable {
  VRFCoordinatorInterface internal _vrfCoordinator; // VRF coordinator contract
  bytes32 public keyHash; // Hash of the public key used to verify the VRF proof
  uint256 public fee; // fee to be paid for the randomness request

  uint32 public requestCounter; // request counter
  mapping(uint32 => uint256) internal _randomNumbers; // mapping from request IDs to random numbers
  mapping(uint256 => uint32) internal _vrfRequestIds; // mapping from VRF request IDs to internal request IDs

  mapping(address => bool) internal _auth; // authorization mapping

  /**
   * @notice Triggered when the VRF coordinator is set
   * @param vrfCoordinator Address of the VRF coordinator
   */
  event VRFCoordinatorSet(VRFCoordinatorInterface vrfCoordinator);

  /**
   * @notice Triggered when the key hash is set
   * @param keyHash Hash of the public key used to verify the VRF proof
   */
  event KeyHashSet(bytes32 keyHash);

  /**
   * @notice Triggered when the VRF request fee is set
   * @param fee Fee to be paid for the randomness request
   */
  event FeeSet(uint256 fee);

  /**
   * @notice Triggered when the given address is authorized
   * @param addr The address to be granted permission to the contract
   * @param authorized Indicate that the address is authorized or unauthorized
   */
  event Authorized(address addr, bool authorized);

  /**
   * @notice Check if the given sender is authorized
   * @param _sender The sender
   */
  modifier authorized(address _sender) {
    require(_sender == owner() || _auth[_sender], "RNGVRF: unauthorized sender");
    _;
  }

  /**
   * @notice Constructor
   * @param vrfCoordinator_ Address of the VRF coordinator
   * @param _keyHash Hash of the public key used to verify the VRF proof
   * @param _fee Fee to be paid for the randomness request
   */
  constructor(
    address vrfCoordinator_,
    bytes32 _keyHash,
    uint256 _fee
  ) Ownable() VRFConsumerBase(vrfCoordinator_) {
    setVRFCoordinator(vrfCoordinator_);
    setKeyHash(_keyHash);
    setFee(_fee);
  }

  /**
   * @inheritdoc RNGInterface
   */
  function requestRandomNumber()
    external
    override
    authorized(msg.sender)
    returns (uint32 requestId)
  {
    uint256 vrfRequestId = _vrfCoordinator.randomnessRequest(keyHash, fee);
    
    requestCounter++;
    requestId = requestCounter;
    _vrfRequestIds[vrfRequestId] = requestId;

    emit RandomNumberRequested(requestId, msg.sender);
  }

  /// @inheritdoc RNGInterface
  function isRequestCompleted(uint32 _requestId)
    external
    view
    override
    returns (bool completed)
  {
    return _randomNumbers[_requestId] != 0;
  }

  /// @inheritdoc RNGInterface
  function getRandomNumber(uint32 _requestId)
    external
    view
    override
    returns (uint256 randomNumber)
  {
    return _randomNumbers[_requestId];
  }

  /// @inheritdoc RNGInterface
  function getLastRequestId()
    external
    view
    override
    returns (uint32 requestId)
  {
    return requestCounter;
  }

  /**
   * @notice Get the VRF coordinator
   * @return The VRF coordinator
   */
  function getVRFCoordinator() external view returns (address) {
    return address(_vrfCoordinator);
  }

  /**
   * @notice Set the VRF coordinator
   * @param vrfCoordinator_ Address of the VRF coordinator
   */
  function setVRFCoordinator(address vrfCoordinator_) public onlyOwner {
    require(vrfCoordinator_ != address(0), "RNGVRF: VRF coordinator must not be zero address");

    _vrfCoordinator = VRFCoordinatorInterface(vrfCoordinator_);

    emit VRFCoordinatorSet(_vrfCoordinator);
  }

  /**
   * @notice Set the key hash
   * @param _keyHash Hash of the public key used to verify the VRF proof
   */
  function setKeyHash(bytes32 _keyHash) public onlyOwner {
    require(_keyHash != 0, "RNGVRF: key hash must not be empty");

    keyHash = _keyHash;
    
    emit KeyHashSet(_keyHash);
  }

  /**
   * @notice Set the VRF request fee
   * @param _fee Fee to be paid for the randomness request
   */
  function setFee(uint256 _fee) public onlyOwner {
    fee = _fee;

    emit FeeSet(_fee);
  }

  /**
   * @notice Authorize the given address
   * @param _address The address to be granted permission to the contract
   * @param _authorized Indicate that the address is authorized or unauthorized
   */
  function authorize(address _address, bool _authorized) external onlyOwner {
    _auth[_address] = _authorized;

    emit Authorized(_address, _authorized);
  }

  /**
   * @notice Callback function invoked by the VRF coordinator
   */
  function fulfillRandomness(uint256 _requestId, uint256 _randomNumber) internal override {
    uint32 internalRequestId = _vrfRequestIds[_requestId];
    require(internalRequestId != 0, "RNGVRF: invalid request ID");

    _randomNumbers[internalRequestId] = _randomNumber;

    emit RandomNumberCompleted(internalRequestId, _randomNumber);
  }
}
