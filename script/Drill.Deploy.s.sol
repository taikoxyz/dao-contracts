// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {SecurityCouncilDrill} from "../src/SecurityCouncilDrill.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DrillDeploy is Script {
    address constant SIGNER_LIST_ADDRESS = 0x0F95E6968EC1B28c794CF1aD99609431de5179c2;

    modifier broadcast() {
        uint256 privKey = vm.envUint("DEPLOYMENT_PRIVATE_KEY");
        vm.startBroadcast(privKey);
        console.log("Deploying from:", vm.addr(privKey));

        _;

        vm.stopBroadcast();
    }

    function run() public broadcast {
        address impl = address(new SecurityCouncilDrill());
        address proxy =
            address(new ERC1967Proxy(impl, abi.encodeCall(SecurityCouncilDrill.initialize, (SIGNER_LIST_ADDRESS))));
        console.log("\nDeployed SecurityCouncilDrill at:", address(proxy));
    }
}
