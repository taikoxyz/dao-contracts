// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import {ContextUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "./SignerList.sol";

contract SecurityCouncilDrill is
    ContextUpgradeable,
    UUPSUpgradeable,
    Ownable2StepUpgradeable,
    AccessControlUpgradeable
{
    /// @notice The nonce of the current drill
    uint256 public drillNonce;
    /// @notice drillNonce => (member => has pinged)
    mapping(uint256 => mapping(address => bool)) public hasPinged;
    /// @notice The address of the SignerList contract
    address public signerList;
    /// @notice Targets for each drill; [0x0] is a global target
    mapping(uint256 => address[]) public targets;

    /// @notice Events
    event SignerListUpdated(address indexed signerList);
    event DrillStarted(uint256 indexed drillNonce, address[] targets);
    event DrillPinged(uint256 indexed drillNonce, address indexed member);
    /// @notice Errors

    error DrillNonceMismatch(uint256 expected, uint256 actual);
    error AlreadyPinged(uint256 drillNonce, address member);
    error NotAuthorized(address member);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the contract
    /// @param _signerList The address of the SignerList contract
    function initialize(address _signerList) external initializer {
        __Ownable2Step_init();
        __UUPSUpgradeable_init();
        __Context_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        signerList = _signerList;
        emit SignerListUpdated(_signerList);
    }

    /// @notice Sets the address of the SignerList contract
    /// @param _signerList The address of the SignerList contract
    /// @dev Only the admin can call this function
    function setSignerList(address _signerList) external virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        signerList = _signerList;
        emit SignerListUpdated(_signerList);
    }

    /// @notice Internal method to start the drill
    /// @param _targets The addresses of the target contracts
    /// @dev Increments the drill nonce
    /// @dev Emits the DrillStarted event
    function _start(address[] memory _targets) internal virtual {
        drillNonce++;
        targets[drillNonce] = _targets;
        emit DrillStarted(drillNonce, _targets);
    }

    /// @notice Starts the drill
    /// @dev Only the admin can call this function
    /// @dev Increments the drill nonce
    function start() external virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        _start(new address[](0));
    }

    // @notice Starts the drill with a single target
    /// @param _target The address of the target contract
    /// @dev Only the admin can call this function
    /// @dev Increments the drill nonce
    function start(address _target) external virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        address[] memory _targets = new address[](1);
        _targets[0] = _target;
        _start(_targets);
    }

    /// @notice Starts the drill with multiple targets
    /// @param _targets The addresses of the target contracts
    /// @dev Only the admin can call this function
    /// @dev Increments the drill nonce
    function start(address[] calldata _targets) external virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        _start(_targets);
    }

    function getTargets(uint256 _drillNonce) external view returns (address[] memory) {
        return targets[_drillNonce];
    }

    /// @notice Pings the drill
    /// @param _drillNonce The nonce of the drill
    /// @dev Only the members of the SignerList can call this function
    /// @dev The caller must not have pinged already
    /// @dev The caller must provide the correct drill nonce
    function ping(uint256 _drillNonce) external virtual {
        if (!Addresslist(signerList).isListed(_msgSender())) {
            revert NotAuthorized(_msgSender());
        }

        if (drillNonce != _drillNonce) {
            revert DrillNonceMismatch(drillNonce, _drillNonce);
        }

        if (hasPinged[_drillNonce][_msgSender()]) {
            revert AlreadyPinged(_drillNonce, _msgSender());
        }

        hasPinged[_drillNonce][_msgSender()] = true;
        emit DrillPinged(_drillNonce, _msgSender());
    }

    /// @notice Internal method to authorize an upgrade
    function _authorizeUpgrade(address) internal virtual override onlyOwner {}

    /// @dev This empty reserved space is put in place to allow future versions to add new
    /// variables without shifting down storage in the inheritance chain.
    /// https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    uint256[47] private __gap;
}
