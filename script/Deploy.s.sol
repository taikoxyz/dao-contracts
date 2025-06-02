// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {TaikoDaoFactory} from "../src/factory/TaikoDaoFactory.sol";
import {IVotesUpgradeable} from "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";
import {GovernanceERC20} from "@aragon/osx/token/ERC20/governance/GovernanceERC20.sol";
import {GovernanceWrappedERC20} from "@aragon/osx/token/ERC20/governance/GovernanceWrappedERC20.sol";
import {MultisigPluginSetup} from "../src/setup/MultisigPluginSetup.sol";
import {EmergencyMultisigPluginSetup} from "../src/setup/EmergencyMultisigPluginSetup.sol";
import {OptimisticTokenVotingPluginSetup} from "../src/setup/OptimisticTokenVotingPluginSetup.sol";
import {DelegationWall} from "../src/DelegationWall.sol";
import {PluginRepoFactory} from "@aragon/osx/framework/plugin/repo/PluginRepoFactory.sol";
import {PluginSetupProcessor} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessor.sol";
import {GovernanceERC20Mock} from "../test/mocks/GovernanceERC20Mock.sol";
import {TaikoL1Mock} from "../test/mocks/TaikoL1Mock.sol";

contract Deploy is Script {
    MultisigPluginSetup multisigPluginSetup;
    EmergencyMultisigPluginSetup emergencyMultisigPluginSetup;
    OptimisticTokenVotingPluginSetup optimisticTokenVotingPluginSetup;

    /// @dev Thrown when attempting to deploy a multisig with no members
    error EmptyMultisig();

    modifier broadcast() {
        uint256 privKey = vm.envUint("DEPLOYMENT_PRIVATE_KEY");
        vm.startBroadcast(privKey);
        console.log("Deploying from:", vm.addr(privKey));

        _;

        vm.stopBroadcast();
    }

    function run() public broadcast {
        // NOTE: Deploying the plugin setup's separately because of the code size limit
        //       EncryptionRegistry and DelegationWall are deployed by the TaikoDaoFactory

        // Deploy the plugin setup's
        multisigPluginSetup = new MultisigPluginSetup();
        emergencyMultisigPluginSetup = new EmergencyMultisigPluginSetup();
        optimisticTokenVotingPluginSetup = new OptimisticTokenVotingPluginSetup(
            GovernanceERC20(vm.envAddress("GOVERNANCE_ERC20_BASE")),
            GovernanceWrappedERC20(vm.envAddress("GOVERNANCE_WRAPPED_ERC20_BASE"))
        );

        console.log("Chain ID:", block.chainid);

        TaikoDaoFactory.DeploymentSettings memory settings;
        if (vm.envOr("MINT_TEST_TOKENS", false)) {
            settings = getTestTokenSettings();
        } else {
            settings = getProductionSettings();
        }

        console.log("");

        TaikoDaoFactory factory = new TaikoDaoFactory(settings);
        factory.deployOnce();

        address delegationWall = address(new DelegationWall());

        // Done
        printDeploymentSummary(factory, delegationWall);
    }

    function getProductionSettings() internal view returns (TaikoDaoFactory.DeploymentSettings memory settings) {
        console.log("Using production settings");

        settings = TaikoDaoFactory.DeploymentSettings({
            // Taiko contract settings
            tokenAddress: IVotesUpgradeable(vm.envAddress("TOKEN_ADDRESS")),
            taikoL1ContractAddress: vm.envAddress("TAIKO_L1_ADDRESS"),
            taikoBridgeAddress: vm.envAddress("TAIKO_BRIDGE_ADDRESS"),
            timelockPeriod: uint32(vm.envUint("TIME_LOCK_PERIOD")),
            l2InactivityPeriod: uint32(vm.envUint("L2_INACTIVITY_PERIOD")),
            l2AggregationGracePeriod: uint32(vm.envUint("L2_AGGREGATION_GRACE_PERIOD")),
            skipL2: bool(vm.envBool("SKIP_L2")),
            // Voting settings
            minVetoRatio: uint32(vm.envUint("MIN_VETO_RATIO")),
            minStdProposalDuration: uint32(vm.envUint("MIN_STD_PROPOSAL_DURATION")),
            minStdApprovals: uint16(vm.envUint("MIN_STD_APPROVALS")),
            minEmergencyApprovals: uint16(vm.envUint("MIN_EMERGENCY_APPROVALS")),
            // OSx contracts
            osxDaoFactory: vm.envAddress("DAO_FACTORY"),
            pluginSetupProcessor: PluginSetupProcessor(vm.envAddress("PLUGIN_SETUP_PROCESSOR")),
            pluginRepoFactory: PluginRepoFactory(vm.envAddress("PLUGIN_REPO_FACTORY")),
            // Plugin setup's
            multisigPluginSetup: MultisigPluginSetup(multisigPluginSetup),
            emergencyMultisigPluginSetup: EmergencyMultisigPluginSetup(emergencyMultisigPluginSetup),
            optimisticTokenVotingPluginSetup: OptimisticTokenVotingPluginSetup(optimisticTokenVotingPluginSetup),
            // Multisig members
            multisigMembers: readMultisigMembers(),
            multisigExpirationPeriod: uint32(vm.envUint("MULTISIG_PROPOSAL_EXPIRATION_PERIOD")),
            // ENS
            stdMultisigEnsDomain: vm.envString("STD_MULTISIG_ENS_DOMAIN"),
            emergencyMultisigEnsDomain: vm.envString("EMERGENCY_MULTISIG_ENS_DOMAIN"),
            optimisticTokenVotingEnsDomain: vm.envString("OPTIMISTIC_TOKEN_VOTING_ENS_DOMAIN")
        });
    }

    function getTestTokenSettings() internal returns (TaikoDaoFactory.DeploymentSettings memory settings) {
        console.log("Using test token settings");

        address taikoBridgeAddress = address(0x1234567890);
        address[] memory multisigMembers = readMultisigMembers();
        address votingToken = createTestToken(multisigMembers, taikoBridgeAddress);

        settings = TaikoDaoFactory.DeploymentSettings({
            // Taiko contract settings
            tokenAddress: IVotesUpgradeable(votingToken),
            taikoL1ContractAddress: address(new TaikoL1Mock()),
            taikoBridgeAddress: taikoBridgeAddress,
            timelockPeriod: uint32(vm.envUint("TIME_LOCK_PERIOD")),
            l2InactivityPeriod: uint32(vm.envUint("L2_INACTIVITY_PERIOD")),
            l2AggregationGracePeriod: uint32(vm.envUint("L2_AGGREGATION_GRACE_PERIOD")),
            skipL2: bool(vm.envBool("SKIP_L2")),
            // Voting settings
            minVetoRatio: uint32(vm.envUint("MIN_VETO_RATIO")),
            minStdProposalDuration: uint32(vm.envUint("MIN_STD_PROPOSAL_DURATION")),
            minStdApprovals: uint16(vm.envUint("MIN_STD_APPROVALS")),
            minEmergencyApprovals: uint16(vm.envUint("MIN_EMERGENCY_APPROVALS")),
            // OSx contracts
            osxDaoFactory: vm.envAddress("DAO_FACTORY"),
            pluginSetupProcessor: PluginSetupProcessor(vm.envAddress("PLUGIN_SETUP_PROCESSOR")),
            pluginRepoFactory: PluginRepoFactory(vm.envAddress("PLUGIN_REPO_FACTORY")),
            // Plugin setup's
            multisigPluginSetup: MultisigPluginSetup(multisigPluginSetup),
            emergencyMultisigPluginSetup: EmergencyMultisigPluginSetup(emergencyMultisigPluginSetup),
            optimisticTokenVotingPluginSetup: OptimisticTokenVotingPluginSetup(optimisticTokenVotingPluginSetup),
            // Multisig members
            multisigMembers: multisigMembers,
            multisigExpirationPeriod: uint32(vm.envUint("MULTISIG_PROPOSAL_EXPIRATION_PERIOD")),
            // ENS
            stdMultisigEnsDomain: vm.envString("STD_MULTISIG_ENS_DOMAIN"),
            emergencyMultisigEnsDomain: vm.envString("EMERGENCY_MULTISIG_ENS_DOMAIN"),
            optimisticTokenVotingEnsDomain: vm.envString("OPTIMISTIC_TOKEN_VOTING_ENS_DOMAIN")
        });
    }

    function printDeploymentSummary(TaikoDaoFactory factory, address delegationWall) internal view {
        TaikoDaoFactory.DeploymentSettings memory settings = factory.getSettings();
        TaikoDaoFactory.Deployment memory daoDeployment = factory.getDeployment();

        console.log("Factory:", address(factory));
        console.log("");
        console.log("DAO:", address(daoDeployment.dao));
        console.log("Voting token:", address(settings.tokenAddress));
        console.log("Taiko Bridge:", settings.taikoBridgeAddress);
        console.log("");

        console.log("Plugins");
        console.log("- Multisig plugin:", address(daoDeployment.multisigPlugin));
        console.log("- Emergency multisig plugin:", address(daoDeployment.emergencyMultisigPlugin));
        console.log("- Optimistic token voting plugin:", address(daoDeployment.optimisticTokenVotingPlugin));
        console.log("");

        console.log("Helpers");
        console.log("- Signer list", address(daoDeployment.signerList));
        console.log("- Encryption registry", address(daoDeployment.encryptionRegistry));
        console.log("- Delegation wall", address(delegationWall));

        console.log("");

        console.log("Plugin repositories");
        console.log("- Multisig plugin repository:", address(daoDeployment.multisigPluginRepo));
        console.log("- Emergency multisig plugin repository:", address(daoDeployment.emergencyMultisigPluginRepo));
        console.log(
            "- Optimistic token voting plugin repository:", address(daoDeployment.optimisticTokenVotingPluginRepo)
        );
    }

    function readMultisigMembers() public view returns (address[] memory result) {
        // JSON list of members
        string memory membersFilePath = vm.envString("MULTISIG_MEMBERS_JSON_FILE_NAME");
        string memory path = string.concat(vm.projectRoot(), membersFilePath);
        string memory strJson = vm.readFile(path);

        bool exists = vm.keyExistsJson(strJson, "$.members");
        if (!exists) revert EmptyMultisig();

        result = vm.parseJsonAddressArray(strJson, "$.members");

        if (result.length == 0) revert EmptyMultisig();
    }

    function createTestToken(address[] memory members, address taikoBridge) internal returns (address) {
        address[] memory allTokenHolders = new address[](members.length + 1);
        for (uint256 i = 0; i < members.length; i++) {
            allTokenHolders[i] = members[i];
        }
        allTokenHolders[members.length] = taikoBridge;

        GovernanceERC20Mock testToken = new GovernanceERC20Mock(address(0));
        console.log("Minting test tokens for the multisig members and the bridge");
        testToken.mintAndDelegate(allTokenHolders, 10 ether);

        return address(testToken);
    }
}
