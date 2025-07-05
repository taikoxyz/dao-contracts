// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {AragonTest} from "./base/AragonTest.sol";
import {SignerList, ISignerList} from "../src/SignerList.sol";
import {DaoBuilder} from "./helpers/DaoBuilder.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {createProxyAndCall} from "../src/helpers/proxy.sol";
import "../src/SecurityCouncilDrill.sol";

contract SecurityCouncilDrillTest is AragonTest {
    SecurityCouncilDrill drill;

    address immutable SIGNER_LIST_BASE = address(new SignerList());
    address[] signers;

    event DrillStarted(uint256 indexed drillNonce, address[] targets);

    function setUp() public {
        vm.startPrank(alice);

        DaoBuilder builder = new DaoBuilder();
        (DAO dao,,,,, SignerList signerList,,) = builder.withMultisigMember(alice).withMultisigMember(bob)
            .withMultisigMember(carol).withMultisigMember(david).build();

        vm.roll(block.number + 1);

        signers = new address[](4);
        signers[0] = alice;
        signers[1] = bob;
        signers[2] = carol;
        signers[3] = david;

        signerList = SignerList(
            createProxyAndCall(address(SIGNER_LIST_BASE), abi.encodeCall(SignerList.initialize, (dao, signers)))
        );

        address impl = address(new SecurityCouncilDrill());
        address proxy =
            address(new ERC1967Proxy(impl, abi.encodeCall(SecurityCouncilDrill.initialize, (address(signerList)))));

        drill = SecurityCouncilDrill(proxy);
    }

    function test_start() public {
        drill.start();
        assertEq(drill.drillNonce(), 1);
    }

    function test_setSignerList() public {
        drill.setSignerList(address(0x123));
        assertEq(drill.signerList(), address(0x123));
    }

    function test_revert_setSignerListIfNotAdmin() public {
        vm.startPrank(bob);
        vm.expectRevert();
        drill.setSignerList(address(0x123));
    }

    function test_startRevertsIfNotAdmin() public {
        vm.startPrank(bob);
        vm.expectRevert();
        drill.start();
    }

    function test_revert_pingIfNotAuthorized() public {
        drill.start();
        address unauthorizedAddress = vm.addr(0x123);
        uint256 nonce = drill.drillNonce();
        vm.startPrank(unauthorizedAddress);
        vm.expectRevert(abi.encodeWithSelector(SecurityCouncilDrill.NotAuthorized.selector, unauthorizedAddress));
        drill.ping(nonce);
    }

    function test_revert_pingIfDrillNonceMismatch() public {
        drill.start();
        uint256 nonce = drill.drillNonce();
        vm.startPrank(alice);
        vm.expectRevert(abi.encodeWithSelector(SecurityCouncilDrill.DrillNonceMismatch.selector, nonce, nonce + 1));
        drill.ping(nonce + 1);
    }

    function test_revert_pingIfPingedAlready() public {
        drill.start();
        uint256 nonce = drill.drillNonce();
        vm.startPrank(alice);
        drill.ping(nonce);
        vm.expectRevert(abi.encodeWithSelector(SecurityCouncilDrill.AlreadyPinged.selector, nonce, alice));
        drill.ping(nonce);
    }

    function test_ping() public {
        drill.start();
        uint256 nonce = drill.drillNonce();
        assertFalse(drill.hasPinged(nonce, alice));
        vm.startPrank(alice);
        drill.ping(nonce);
        assertTrue(drill.hasPinged(nonce, alice));
        vm.stopPrank();

        assertFalse(drill.hasPinged(nonce, bob));
        vm.prank(bob);
        drill.ping(nonce);
        assertTrue(drill.hasPinged(nonce, bob));

        assertFalse(drill.hasPinged(nonce, carol));
        assertFalse(drill.hasPinged(nonce, david));
    }

    function test_start_singleTarget() public {
        address target = address(0x123);
        // Check that the event was emitted with the correct target
        drill.start(target);
        assertEq(drill.drillNonce(), 1);
        address[] memory targets = drill.getTargets(1);
        assertEq(targets.length, 1);
        assertEq(targets[0], target);
    }

    function test_start_multipleTargets() public {
        address[] memory targets = new address[](3);
        targets[0] = address(0x123);
        targets[1] = address(0x456);
        targets[2] = address(0x789);

        // Check that the event was emitted with the correct targets
        drill.start(targets);
        assertEq(drill.drillNonce(), 1);
        address[] memory storedTargets = drill.getTargets(1);
        assertEq(storedTargets.length, 3);
        assertEq(storedTargets[0], targets[0]);
        assertEq(storedTargets[1], targets[1]);
        assertEq(storedTargets[2], targets[2]);
    }
}
