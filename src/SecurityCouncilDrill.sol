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

    /// @notice Events
    event SignerListUpdated(address indexed signerList);
    event DrillStarted(uint256 indexed drillNonce);
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

    /// @notice Starts the drill
    /// @dev Only the admin can call this function
    /// @dev Increments the drill nonce
    function start() external virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        drillNonce++;
        emit DrillStarted(drillNonce);
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
    uint256[50] private __gap;
}
