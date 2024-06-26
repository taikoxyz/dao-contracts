// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {VmSafe} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";
import {OptimisticTokenVotingPlugin} from "../src/OptimisticTokenVotingPlugin.sol";
import {OptimisticTokenVotingPluginSetup} from "../src/setup/OptimisticTokenVotingPluginSetup.sol";
import {MultisigPluginSetup} from "../src/setup/MultisigPluginSetup.sol";
import {EmergencyMultisigPluginSetup} from "../src/setup/EmergencyMultisigPluginSetup.sol";
import {GovernanceERC20} from "@aragon/osx/token/ERC20/governance/GovernanceERC20.sol";
import {GovernanceWrappedERC20} from "@aragon/osx/token/ERC20/governance/GovernanceWrappedERC20.sol";
import {PluginRepoFactory} from "@aragon/osx/framework/plugin/repo/PluginRepoFactory.sol";
import {hashHelpers, PluginSetupRef} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessorHelpers.sol";
import {Addresslist} from "@aragon/osx/plugins/utils/Addresslist.sol";
import {Multisig} from "../src/Multisig.sol";
import {EmergencyMultisig} from "../src/EmergencyMultisig.sol";
import {PublicKeyRegistry} from "../src/PublicKeyRegistry.sol";
import {PluginRepo} from "@aragon/osx/framework/plugin/repo/PluginRepo.sol";
import {IPluginSetup} from "@aragon/osx/framework/plugin/setup/IPluginSetup.sol";
import {PluginSetupProcessor} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessor.sol";
import {IDAO} from "@aragon/osx/core/dao/IDAO.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {createERC1967Proxy} from "@aragon/osx/utils/Proxy.sol";
import {TaikoL1} from "../src/adapted-dependencies/TaikoL1.sol";

contract Deploy is Script {
    DAO immutable daoImplementation;

    address immutable governanceERC20Base;
    address immutable governanceWrappedERC20Base;
    PluginSetupProcessor immutable pluginSetupProcessor;
    address immutable pluginRepoFactory;

    uint32 immutable minVetoRatio;
    uint64 immutable l2InactivityPeriod;
    uint64 immutable l2AggregationGracePeriod;
    address immutable tokenAddress;
    address immutable taikoL1;
    address immutable taikoBridge;

    uint64 immutable minStdProposalDelay; // Minimum delay of proposals on the optimistic voting plugin
    uint16 immutable minStdApprovals;
    uint16 immutable minEmergencyApprovals;

    address[] multisigMembers;

    string stdMultisigEnsDomain;
    string emergencyMultisigEnsDomain;
    string optimisticTokenVotingEnsDomain;

    constructor() {
        // Implementations
        daoImplementation = new DAO();

        governanceERC20Base = vm.envAddress("GOVERNANCE_ERC20_BASE");
        governanceWrappedERC20Base = vm.envAddress("GOVERNANCE_WRAPPED_ERC20_BASE");
        pluginSetupProcessor = PluginSetupProcessor(vm.envAddress("PLUGIN_SETUP_PROCESSOR"));
        pluginRepoFactory = vm.envAddress("PLUGIN_REPO_FACTORY");

        minVetoRatio = uint32(vm.envUint("MIN_VETO_RATIO"));
        l2InactivityPeriod = uint64(vm.envUint("L2_INACTIVITY_PERIOD"));
        l2AggregationGracePeriod = uint64(vm.envUint("L2_AGGREGATION_GRACE_PERIOD"));
        tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        taikoL1 = vm.envAddress("TAIKO_L1_ADDRESS");
        taikoBridge = vm.envAddress("TAIKO_BRIDGE_ADDRESS");

        minStdProposalDelay = uint64(vm.envUint("MIN_STD_PROPOSAL_DELAY"));
        minStdApprovals = uint16(vm.envUint("MIN_STD_APPROVALS"));
        minEmergencyApprovals = uint16(vm.envUint("MIN_EMERGENCY_APPROVALS"));

        // JSON list of members
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/utils/members.json");
        string memory json = vm.readFile(path);
        multisigMembers = vm.parseJsonAddressArray(json, "$.addresses");

        stdMultisigEnsDomain = vm.envString("STD_MULTISIG_ENS_DOMAIN");
        emergencyMultisigEnsDomain = vm.envString("EMERGENCY_MULTISIG_ENS_DOMAIN");
        optimisticTokenVotingEnsDomain = vm.envString("OPTIMISTIC_TOKEN_VOTING_ENS_DOMAIN");
    }

    function run() public {
        // Deploy a raw DAO
        DAO dao = prepareDao();

        // Prepare plugins
        (address p1, PluginRepo pr1, IPluginSetup.PreparedSetupData memory preparedSetupData1) = prepareMultisig(dao);

        (address p2, PluginRepo pr2, IPluginSetup.PreparedSetupData memory preparedSetupData2) =
            prepareEmergencyMultisig(dao, Addresslist(p1));

        (address p3, PluginRepo pr3, IPluginSetup.PreparedSetupData memory preparedSetupData3) =
            prepareOptimisticTokenVoting(dao, p1, p2);

        // Apply installations
        dao.grant(address(dao), address(pluginSetupProcessor), dao.ROOT_PERMISSION_ID());

        applyPluginInstallation(dao, p1, pr1, preparedSetupData1);
        applyPluginInstallation(dao, p2, pr2, preparedSetupData2);
        applyPluginInstallation(dao, p3, pr3, preparedSetupData3);

        dao.revoke(address(dao), address(pluginSetupProcessor), dao.ROOT_PERMISSION_ID());

        address publicKeyRegistry = deployPublicKeyRegistry();

        // Remove ourselves as root

        dao.revoke(address(dao), getDeployerWallet(), dao.ROOT_PERMISSION_ID());

        // Print summary
        console.log("DAO contract", address(dao));
        console.log("");

        console.log("Multisig plugin", p1);
        console.log("Emergency multisig plugin", p2);
        console.log("Optimistic token voting plugin", p3);
        console.log("");

        console.log("Multisig plugin repository", address(pr1));
        console.log("Emergency multisig plugin repository", address(pr2));
        console.log("Optimistic token voting plugin repository", address(pr3));
        console.log("");

        console.log("Public key registry", publicKeyRegistry);
    }

    // Helpers

    function prepareDeployerWallet() internal {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        // vm.stopBroadcast();
    }

    function getDeployerWallet() private returns (address) {
        VmSafe.Wallet memory wallet = vm.createWallet(vm.envUint("PRIVATE_KEY"));

        return address(uint160(uint256(keccak256(abi.encode(wallet.publicKeyX, wallet.publicKeyY)))));
    }

    function prepareDao() internal returns (DAO dao) {
        dao = DAO(
            payable(
                createERC1967Proxy(
                    address(daoImplementation),
                    abi.encodeCall(
                        DAO.initialize,
                        (
                            "", // Metadata URI
                            getDeployerWallet(),
                            address(0x0),
                            "" // DAO URI
                        )
                    )
                )
            )
        );
    }

    function prepareMultisig(DAO dao) internal returns (address, PluginRepo, IPluginSetup.PreparedSetupData memory) {
        // Deploy plugin setup
        MultisigPluginSetup pluginSetup = new MultisigPluginSetup();

        // Publish repo
        PluginRepo pluginRepo = PluginRepoFactory(pluginRepoFactory).createPluginRepoWithFirstVersion(
            stdMultisigEnsDomain, address(pluginSetup), msg.sender, "", ""
        );

        bytes memory settingsData = pluginSetup.encodeInstallationParameters(
            multisigMembers,
            Multisig.MultisigSettings(
                true, // onlyListed
                minStdApprovals, // minAppovals
                minStdProposalDelay // destination minDuration
            )
        );

        (address plugin, IPluginSetup.PreparedSetupData memory preparedSetupData) = pluginSetupProcessor
            .prepareInstallation(
            address(dao),
            PluginSetupProcessor.PrepareInstallationParams(
                PluginSetupRef(PluginRepo.Tag(1, 1), PluginRepo(pluginRepo)), settingsData
            )
        );

        return (plugin, pluginRepo, preparedSetupData);
    }

    function prepareEmergencyMultisig(DAO dao, Addresslist multisigPlugin)
        internal
        returns (address, PluginRepo, IPluginSetup.PreparedSetupData memory)
    {
        // Deploy plugin setup
        EmergencyMultisigPluginSetup pluginSetup = new EmergencyMultisigPluginSetup();

        // Publish repo
        PluginRepo pluginRepo = PluginRepoFactory(pluginRepoFactory).createPluginRepoWithFirstVersion(
            emergencyMultisigEnsDomain, address(pluginSetup), msg.sender, "", ""
        );

        bytes memory settingsData = pluginSetup.encodeInstallationParameters(
            multisigMembers,
            EmergencyMultisig.MultisigSettings(
                true, // onlyListed
                minEmergencyApprovals, // minAppovals
                Addresslist(multisigPlugin)
            )
        );

        (address plugin, IPluginSetup.PreparedSetupData memory preparedSetupData) = pluginSetupProcessor
            .prepareInstallation(
            address(dao),
            PluginSetupProcessor.PrepareInstallationParams(
                PluginSetupRef(PluginRepo.Tag(1, 1), PluginRepo(pluginRepo)), settingsData
            )
        );

        return (plugin, pluginRepo, preparedSetupData);
    }

    function prepareOptimisticTokenVoting(DAO dao, address stdProposer, address emergencyProposer)
        internal
        returns (address plugin, PluginRepo pluginRepo, IPluginSetup.PreparedSetupData memory preparedSetupData)
    {
        // Deploy plugin setup
        OptimisticTokenVotingPluginSetup pluginSetup = new OptimisticTokenVotingPluginSetup(
            GovernanceERC20(governanceERC20Base), GovernanceWrappedERC20(governanceWrappedERC20Base)
        );

        // Publish repo
        pluginRepo = PluginRepoFactory(pluginRepoFactory).createPluginRepoWithFirstVersion(
            optimisticTokenVotingEnsDomain, address(pluginSetup), msg.sender, "", ""
        );

        // Plugin settings
        bytes memory settingsData;
        {
            OptimisticTokenVotingPlugin.OptimisticGovernanceSettings memory votingSettings = OptimisticTokenVotingPlugin
                .OptimisticGovernanceSettings(
                minVetoRatio,
                0, // minDuration (the condition contract will enforce it)
                l2InactivityPeriod,
                l2AggregationGracePeriod
            );

            OptimisticTokenVotingPluginSetup.TokenSettings memory tokenSettings =
                OptimisticTokenVotingPluginSetup.TokenSettings(tokenAddress, "", "");

            GovernanceERC20.MintSettings memory mintSettings =
                GovernanceERC20.MintSettings(new address[](0), new uint256[](0));

            settingsData = pluginSetup.encodeInstallationParams(
                OptimisticTokenVotingPluginSetup.InstallationParameters(
                    votingSettings,
                    tokenSettings,
                    mintSettings,
                    TaikoL1(taikoL1),
                    taikoBridge,
                    minStdProposalDelay,
                    stdProposer,
                    emergencyProposer
                )
            );
        }

        (plugin, preparedSetupData) = pluginSetupProcessor.prepareInstallation(
            address(dao),
            PluginSetupProcessor.PrepareInstallationParams(
                PluginSetupRef(PluginRepo.Tag(1, 1), PluginRepo(pluginRepo)), settingsData
            )
        );

        return (plugin, pluginRepo, preparedSetupData);
    }

    function applyPluginInstallation(
        DAO dao,
        address plugin,
        PluginRepo pluginRepo,
        IPluginSetup.PreparedSetupData memory preparedSetupData
    ) internal {
        IDAO.Action[] memory actions = new IDAO.Action[](1);
        actions[0] = IDAO.Action(
            address(dao),
            0,
            abi.encodeCall(
                PluginSetupProcessor.applyInstallation,
                (
                    address(dao),
                    PluginSetupProcessor.ApplyInstallationParams(
                        PluginSetupRef(PluginRepo.Tag(1, 1), pluginRepo),
                        plugin,
                        preparedSetupData.permissions,
                        hashHelpers(preparedSetupData.helpers)
                    )
                )
            )
        );
        dao.execute(bytes32(uint256(0x1)), actions, 0);
    }

    function deployPublicKeyRegistry() internal returns (address) {
        return address(new PublicKeyRegistry());
    }
}
