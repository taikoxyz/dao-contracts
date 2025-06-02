# Test tree definitions

Below is the graphical definition of the contract tests implemented on [the test folder](./test)

```
EmergencyMultisigTest
├── When deploying the contract
│   └── It should disable the initializers
├── Given a new proxy contract
│   └── Given calling initialize
│       ├── It should initialize the first time
│       ├── It should refuse to initialize again
│       ├── It should set the DAO address
│       ├── It should set the minApprovals
│       ├── It should set onlyListed
│       ├── It should set signerList
│       ├── It should set proposalExpirationPeriod
│       ├── It should emit MultisigSettingsUpdated
│       ├── When minApprovals is greater than signerList length on initialize
│       │   ├── It should revert
│       │   ├── It should revert (with onlyListed false)
│       │   └── It should not revert otherwise
│       ├── When minApprovals is zero on initialize
│       │   ├── It should revert
│       │   ├── It should revert (with onlyListed false)
│       │   └── It should not revert otherwise
│       └── When signerList is invalid on initialize
│           └── It should revert
├── When calling upgradeTo
│   ├── It should revert when called without the permission
│   └── It should work when called with the permission
├── When calling upgradeToAndCall
│   ├── It should revert when called without the permission
│   └── It should work when called with the permission
├── When calling supportsInterface
│   ├── It does not support the empty interface
│   ├── It supports IERC165Upgradeable
│   ├── It supports IPlugin
│   ├── It supports IProposal
│   └── It supports IEmergencyMultisig
├── When calling updateSettings
│   ├── Given caller has no permission
│   │   ├── It should revert
│   │   └── It otherwise it should just work
│   ├── It should set the minApprovals
│   ├── It should set onlyListed
│   ├── It should set signerList
│   ├── It should set proposalExpirationPeriod
│   ├── It should emit MultisigSettingsUpdated
│   ├── When minApprovals is greater than signerList length on updateSettings
│   │   ├── It should revert
│   │   ├── It should revert (with onlyListed false)
│   │   └── It should not revert otherwise
│   ├── When minApprovals is zero on updateSettings
│   │   ├── It should revert
│   │   ├── It should revert (with onlyListed false)
│   │   └── It should not revert otherwise
│   └── When signerList is invalid on updateSettings
│       └── It should revert
├── When calling createProposal
│   ├── It increments the proposal counter
│   ├── It creates and return unique proposal IDs
│   ├── It emits the ProposalCreated event
│   ├── It creates a proposal with the given values
│   ├── Given settings changed on the same block
│   │   ├── It reverts
│   │   └── It does not revert otherwise
│   ├── Given onlyListed is false
│   │   └── It allows anyone to create
│   ├── Given onlyListed is true
│   │   ├── Given creation caller is not listed or appointed
│   │   │   ├── It reverts
│   │   │   └── It reverts if listed before but not now
│   │   ├── Given creation caller is appointed by a former signer
│   │   │   └── It reverts
│   │   ├── Given creation caller is listed and self appointed
│   │   │   └── It creates the proposal
│   │   ├── Given creation caller is listed appointing someone else now
│   │   │   └── It creates the proposal
│   │   └── Given creation caller is appointed by a current signer
│   │       └── It creates the proposal
│   ├── Given approveProposal is true
│   │   └── It creates and calls approval in one go
│   └── Given approveProposal is false
│       └── It only creates the proposal
├── When calling hashActions
│   ├── It returns the right result
│   ├── It reacts to any of the values changing
│   └── It same input produces the same output
├── Given The proposal is not created
│   ├── When calling getProposal being uncreated
│   │   └── It should return empty values
│   ├── When calling canApprove or approve being uncreated
│   │   ├── It canApprove should return false (when listed and self appointed)
│   │   ├── It approve should revert (when listed and self appointed)
│   │   ├── It canApprove should return false (when listed, appointing someone else now)
│   │   ├── It approve should revert (when listed, appointing someone else now)
│   │   ├── It canApprove should return false (when appointed by a listed signer)
│   │   ├── It approve should revert (when appointed by a listed signer)
│   │   ├── It canApprove should return false (when unlisted and unappointed)
│   │   └── It approve should revert (when unlisted and unappointed)
│   ├── When calling hasApproved being uncreated
│   │   └── It hasApproved should always return false
│   └── When calling canExecute or execute being uncreated
│       └── It canExecute should always return false
├── Given The proposal is open
│   ├── When calling getProposal being open
│   │   └── It should return the right values
│   ├── When calling canApprove or approve being open
│   │   ├── It canApprove should return true (when listed on creation, self appointed now)
│   │   ├── It approve should work (when listed on creation, self appointed now)
│   │   ├── It approve should emit an event (when listed on creation, self appointed now)
│   │   ├── It canApprove should return false (when listed on creation, appointing someone else now)
│   │   ├── It approve should revert (when listed on creation, appointing someone else now)
│   │   ├── It canApprove should return true (when currently appointed by a signer listed on creation)
│   │   ├── It approve should work (when currently appointed by a signer listed on creation)
│   │   ├── It approve should emit an event (when currently appointed by a signer listed on creation)
│   │   ├── It canApprove should return false (when unlisted on creation, unappointed now)
│   │   └── It approve should revert (when unlisted on creation, unappointed now)
│   ├── When calling hasApproved being open
│   │   └── It hasApproved should return false until approved
│   └── When calling canExecute or execute being open
│       ├── It canExecute should return false (when listed on creation, self appointed now)
│       ├── It execute should revert (when listed on creation, self appointed now)
│       ├── It canExecute should return false (when listed on creation, appointing someone else now)
│       ├── It execute should revert (when listed on creation, appointing someone else now)
│       ├── It canExecute should return false (when currently appointed by a signer listed on creation)
│       ├── It execute should revert (when currently appointed by a signer listed on creation)
│       ├── It canExecute should return false (when unlisted on creation, unappointed now)
│       └── It execute should revert (when unlisted on creation, unappointed now)
├── Given The proposal was approved by the address
│   ├── When calling getProposal being approved
│   │   └── It should return the right values
│   ├── When calling canApprove or approve being approved
│   │   ├── It canApprove should return false (when listed on creation, self appointed now)
│   │   ├── It approve should revert (when listed on creation, self appointed now)
│   │   ├── It canApprove should return false (when currently appointed by a signer listed on creation)
│   │   └── It approve should revert (when currently appointed by a signer listed on creation)
│   ├── When calling hasApproved being approved
│   │   └── It hasApproved should return false until approved
│   └── When calling canExecute or execute being approved
│       ├── It canExecute should return false (when listed on creation, self appointed now)
│       ├── It execute should revert (when listed on creation, self appointed now)
│       ├── It canExecute should return false (when currently appointed by a signer listed on creation)
│       └── It execute should revert (when currently appointed by a signer listed on creation)
├── Given The proposal passed
│   ├── When calling getProposal being passed
│   │   └── It should return the right values
│   ├── When calling canApprove or approve being passed
│   │   ├── It canApprove should return false (when listed on creation, self appointed now)
│   │   ├── It approve should revert (when listed on creation, self appointed now)
│   │   ├── It canApprove should return false (when listed on creation, appointing someone else now)
│   │   ├── It approve should revert (when listed on creation, appointing someone else now)
│   │   ├── It canApprove should return false (when currently appointed by a signer listed on creation)
│   │   ├── It approve should revert (when currently appointed by a signer listed on creation)
│   │   ├── It canApprove should return false (when unlisted on creation, unappointed now)
│   │   └── It approve should revert (when unlisted on creation, unappointed now)
│   ├── When calling hasApproved being passed
│   │   └── It hasApproved should return false until approved
│   ├── When calling canExecute or execute with modified data being passed
│   │   ├── It execute should revert with modified metadata
│   │   ├── It execute should revert with modified actions
│   │   └── It execute should work with matching data
│   ├── When calling canExecute or execute being passed
│   │   ├── It canExecute should return true, always
│   │   ├── It execute should work, when called by anyone with the actions
│   │   ├── It execute should emit an event, when called by anyone with the actions
│   │   ├── It execute recreates the proposal on the destination plugin
│   │   ├── It The parameters of the recreated proposal match the hash of the executed one
│   │   ├── It A ProposalCreated event is emitted on the destination plugin
│   │   └── It Execution is immediate on the destination plugin
│   └── Given TaikoL1 is incompatible
│       └── It executes successfully, regardless
├── Given The proposal is already executed
│   ├── When calling getProposal being executed
│   │   └── It should return the right values
│   ├── When calling canApprove or approve being executed
│   │   ├── It canApprove should return false (when listed on creation, self appointed now)
│   │   ├── It approve should revert (when listed on creation, self appointed now)
│   │   ├── It canApprove should return false (when listed on creation, appointing someone else now)
│   │   ├── It approve should revert (when listed on creation, appointing someone else now)
│   │   ├── It canApprove should return false (when currently appointed by a signer listed on creation)
│   │   ├── It approve should revert (when currently appointed by a signer listed on creation)
│   │   ├── It canApprove should return false (when unlisted on creation, unappointed now)
│   │   └── It approve should revert (when unlisted on creation, unappointed now)
│   ├── When calling hasApproved being executed
│   │   └── It hasApproved should return false until approved
│   └── When calling canExecute or execute being executed
│       ├── It canExecute should return false (when listed on creation, self appointed now)
│       ├── It execute should revert (when listed on creation, self appointed now)
│       ├── It canExecute should return false (when listed on creation, appointing someone else now)
│       ├── It execute should revert (when listed on creation, appointing someone else now)
│       ├── It canExecute should return false (when currently appointed by a signer listed on creation)
│       ├── It execute should revert (when currently appointed by a signer listed on creation)
│       ├── It canExecute should return false (when unlisted on creation, unappointed now)
│       └── It execute should revert (when unlisted on creation, unappointed now)
└── Given The proposal expired
    ├── When calling getProposal being expired
    │   └── It should return the right values
    ├── When calling canApprove or approve being expired
    │   ├── It canApprove should return false (when listed on creation, self appointed now)
    │   ├── It approve should revert (when listed on creation, self appointed now)
    │   ├── It canApprove should return false (when listed on creation, appointing someone else now)
    │   ├── It approve should revert (when listed on creation, appointing someone else now)
    │   ├── It canApprove should return false (when currently appointed by a signer listed on creation)
    │   ├── It approve should revert (when currently appointed by a signer listed on creation)
    │   ├── It canApprove should return false (when unlisted on creation, unappointed now)
    │   └── It approve should revert (when unlisted on creation, unappointed now)
    ├── When calling hasApproved being expired
    │   └── It hasApproved should return false until approved
    └── When calling canExecute or execute being expired
        ├── It canExecute should return false (when listed on creation, self appointed now)
        ├── It execute should revert (when listed on creation, self appointed now)
        ├── It canExecute should return false (when listed on creation, appointing someone else now)
        ├── It execute should revert (when listed on creation, appointing someone else now)
        ├── It canExecute should return false (when currently appointed by a signer listed on creation)
        ├── It execute should revert (when currently appointed by a signer listed on creation)
        ├── It canExecute should return false (when unlisted on creation, unappointed now)
        └── It execute should revert (when unlisted on creation, unappointed now)
```

```
MultisigTest
├── When deploying the contract
│   └── It should disable the initializers
├── Given a new proxy contract
│   └── Given calling initialize
│       ├── It should initialize the first time
│       ├── It should refuse to initialize again
│       ├── It should set the DAO address
│       ├── It should set the minApprovals
│       ├── It should set onlyListed
│       ├── It should set signerList
│       ├── It should set destinationProposalDuration
│       ├── It should set proposalExpirationPeriod
│       ├── It should emit MultisigSettingsUpdated
│       ├── When minApprovals is greater than signerList length on initialize
│       │   ├── It should revert
│       │   ├── It should revert (with onlyListed false)
│       │   └── It should not revert otherwise
│       ├── When minApprovals is zero on initialize
│       │   ├── It should revert
│       │   ├── It should revert (with onlyListed false)
│       │   └── It should not revert otherwise
│       └── When signerList is invalid on initialize
│           └── It should revert
├── When calling upgradeTo
│   ├── It should revert when called without the permission
│   └── It should work when called with the permission
├── When calling upgradeToAndCall
│   ├── It should revert when called without the permission
│   └── It should work when called with the permission
├── When calling supportsInterface
│   ├── It does not support the empty interface
│   ├── It supports IERC165Upgradeable
│   ├── It supports IPlugin
│   ├── It supports IProposal
│   └── It supports IMultisig
├── When calling updateSettings
│   ├── Given caller has no permission
│   │   ├── It should revert
│   │   └── It otherwise it should just work
│   ├── It should set the minApprovals
│   ├── It should set onlyListed
│   ├── It should set signerList
│   ├── It should set destinationProposalDuration
│   ├── It should set proposalExpirationPeriod
│   ├── It should emit MultisigSettingsUpdated
│   ├── When minApprovals is greater than signerList length on updateSettings
│   │   ├── It should revert
│   │   ├── It should revert (with onlyListed false)
│   │   └── It should not revert otherwise
│   ├── When minApprovals is zero on updateSettings
│   │   ├── It should revert
│   │   ├── It should revert (with onlyListed false)
│   │   └── It should not revert otherwise
│   └── When signerList is invalid on updateSettings
│       └── It should revert
├── When calling createProposal
│   ├── It increments the proposal counter
│   ├── It creates and return unique proposal IDs
│   ├── It emits the ProposalCreated event
│   ├── It creates a proposal with the given values
│   ├── Given settings changed on the same block
│   │   ├── It reverts
│   │   └── It does not revert otherwise
│   ├── Given onlyListed is false
│   │   └── It allows anyone to create
│   ├── Given onlyListed is true
│   │   ├── Given creation caller is not listed or appointed
│   │   │   ├── It reverts
│   │   │   └── It reverts if listed before but not now
│   │   ├── Given creation caller is appointed by a former signer
│   │   │   └── It reverts
│   │   ├── Given creation caller is listed and self appointed
│   │   │   └── It creates the proposal
│   │   ├── Given creation caller is listed appointing someone else now
│   │   │   └── It creates the proposal
│   │   └── Given creation caller is appointed by a current signer
│   │       └── It creates the proposal
│   ├── Given approveProposal is true
│   │   └── It creates and calls approval in one go
│   └── Given approveProposal is false
│       └── It only creates the proposal
├── Given The proposal is not created
│   ├── When calling getProposal being uncreated
│   │   └── It should return empty values
│   ├── When calling canApprove or approve being uncreated
│   │   ├── It canApprove should return false (when listed and self appointed)
│   │   ├── It approve should revert (when listed and self appointed)
│   │   ├── It canApprove should return false (when listed, appointing someone else now)
│   │   ├── It approve should revert (when listed, appointing someone else now)
│   │   ├── It canApprove should return false (when appointed by a listed signer)
│   │   ├── It approve should revert (when appointed by a listed signer)
│   │   ├── It canApprove should return false (when unlisted and unappointed)
│   │   └── It approve should revert (when unlisted and unappointed)
│   ├── When calling hasApproved being uncreated
│   │   └── It hasApproved should always return false
│   └── When calling canExecute or execute being uncreated
│       ├── It canExecute should return false (when listed and self appointed)
│       ├── It execute should revert (when listed and self appointed)
│       ├── It canExecute should return false (when listed, appointing someone else now)
│       ├── It execute should revert (when listed, appointing someone else now)
│       ├── It canExecute should return false (when appointed by a listed signer)
│       ├── It execute should revert (when appointed by a listed signer)
│       ├── It canExecute should return false (when unlisted and unappointed)
│       └── It execute should revert (when unlisted and unappointed)
├── Given The proposal is open
│   ├── When calling getProposal being open
│   │   └── It should return the right values
│   ├── When calling canApprove or approve being open
│   │   ├── It canApprove should return true (when listed on creation, self appointed now)
│   │   ├── It approve should work (when listed on creation, self appointed now)
│   │   ├── It approve should emit an event (when listed on creation, self appointed now)
│   │   ├── It canApprove should return false (when listed on creation, appointing someone else now)
│   │   ├── It approve should revert (when listed on creation, appointing someone else now)
│   │   ├── It canApprove should return true (when currently appointed by a signer listed on creation)
│   │   ├── It approve should work (when currently appointed by a signer listed on creation)
│   │   ├── It approve should emit an event (when currently appointed by a signer listed on creation)
│   │   ├── It canApprove should return false (when unlisted on creation, unappointed now)
│   │   └── It approve should revert (when unlisted on creation, unappointed now)
│   ├── When calling approve with tryExecution and almost passed being open
│   │   ├── It approve should also execute the proposal
│   │   ├── It approve should emit an Executed event
│   │   ├── It approve recreates the proposal on the destination plugin
│   │   ├── It The parameters of the recreated proposal match those of the approved one
│   │   └── It A ProposalCreated event is emitted on the destination plugin
│   ├── When calling hasApproved being open
│   │   └── It hasApproved should return false until approved
│   └── When calling canExecute or execute being open
│       ├── It canExecute should return false (when listed on creation, self appointed now)
│       ├── It execute should revert (when listed on creation, self appointed now)
│       ├── It canExecute should return false (when listed on creation, appointing someone else now)
│       ├── It execute should revert (when listed on creation, appointing someone else now)
│       ├── It canExecute should return false (when currently appointed by a signer listed on creation)
│       ├── It execute should revert (when currently appointed by a signer listed on creation)
│       ├── It canExecute should return false (when unlisted on creation, unappointed now)
│       └── It execute should revert (when unlisted on creation, unappointed now)
├── Given The proposal was approved by the address
│   ├── When calling getProposal being approved
│   │   └── It should return the right values
│   ├── When calling canApprove or approve being approved
│   │   ├── It canApprove should return false (when listed on creation, self appointed now)
│   │   ├── It approve should revert (when listed on creation, self appointed now)
│   │   ├── It canApprove should return false (when currently appointed by a signer listed on creation)
│   │   └── It approve should revert (when currently appointed by a signer listed on creation)
│   ├── When calling hasApproved being approved
│   │   └── It hasApproved should return false until approved
│   └── When calling canExecute or execute being approved
│       ├── It canExecute should return false (when listed on creation, self appointed now)
│       ├── It execute should revert (when listed on creation, self appointed now)
│       ├── It canExecute should return false (when currently appointed by a signer listed on creation)
│       └── It execute should revert (when currently appointed by a signer listed on creation)
├── Given The proposal passed
│   ├── When calling getProposal being passed
│   │   └── It should return the right values
│   ├── When calling canApprove or approve being passed
│   │   ├── It canApprove should return false (when listed on creation, self appointed now)
│   │   ├── It approve should revert (when listed on creation, self appointed now)
│   │   ├── It canApprove should return false (when listed on creation, appointing someone else now)
│   │   ├── It approve should revert (when listed on creation, appointing someone else now)
│   │   ├── It canApprove should return false (when currently appointed by a signer listed on creation)
│   │   ├── It approve should revert (when currently appointed by a signer listed on creation)
│   │   ├── It canApprove should return false (when unlisted on creation, unappointed now)
│   │   └── It approve should revert (when unlisted on creation, unappointed now)
│   ├── When calling hasApproved being passed
│   │   └── It hasApproved should return false until approved
│   ├── When calling canExecute or execute being passed
│   │   ├── It canExecute should return true, always
│   │   ├── It execute should work, when called by anyone
│   │   ├── It execute should emit an event, when called by anyone
│   │   ├── It execute recreates the proposal on the destination plugin
│   │   ├── It The parameters of the recreated proposal match those of the executed one
│   │   ├── It The proposal duration on the destination plugin matches the multisig settings
│   │   └── It A ProposalCreated event is emitted on the destination plugin
│   └── Given TaikoL1 is incompatible
│       └── It executes successfully, regardless
├── Given The proposal is already executed
│   ├── When calling getProposal being executed
│   │   └── It should return the right values
│   ├── When calling canApprove or approve being executed
│   │   ├── It canApprove should return false (when listed on creation, self appointed now)
│   │   ├── It approve should revert (when listed on creation, self appointed now)
│   │   ├── It canApprove should return false (when listed on creation, appointing someone else now)
│   │   ├── It approve should revert (when listed on creation, appointing someone else now)
│   │   ├── It canApprove should return false (when currently appointed by a signer listed on creation)
│   │   ├── It approve should revert (when currently appointed by a signer listed on creation)
│   │   ├── It canApprove should return false (when unlisted on creation, unappointed now)
│   │   └── It approve should revert (when unlisted on creation, unappointed now)
│   ├── When calling hasApproved being executed
│   │   └── It hasApproved should return false until approved
│   └── When calling canExecute or execute being executed
│       ├── It canExecute should return false (when listed on creation, self appointed now)
│       ├── It execute should revert (when listed on creation, self appointed now)
│       ├── It canExecute should return false (when listed on creation, appointing someone else now)
│       ├── It execute should revert (when listed on creation, appointing someone else now)
│       ├── It canExecute should return false (when currently appointed by a signer listed on creation)
│       ├── It execute should revert (when currently appointed by a signer listed on creation)
│       ├── It canExecute should return false (when unlisted on creation, unappointed now)
│       └── It execute should revert (when unlisted on creation, unappointed now)
└── Given The proposal expired
    ├── When calling getProposal being expired
    │   └── It should return the right values
    ├── When calling canApprove or approve being expired
    │   ├── It canApprove should return false (when listed on creation, self appointed now)
    │   ├── It approve should revert (when listed on creation, self appointed now)
    │   ├── It canApprove should return false (when listed on creation, appointing someone else now)
    │   ├── It approve should revert (when listed on creation, appointing someone else now)
    │   ├── It canApprove should return false (when currently appointed by a signer listed on creation)
    │   ├── It approve should revert (when currently appointed by a signer listed on creation)
    │   ├── It canApprove should return false (when unlisted on creation, unappointed now)
    │   └── It approve should revert (when unlisted on creation, unappointed now)
    ├── When calling hasApproved being expired
    │   └── It hasApproved should return false until approved
    └── When calling canExecute or execute being expired
        ├── It canExecute should return false (when listed on creation, self appointed now)
        ├── It execute should revert (when listed on creation, self appointed now)
        ├── It canExecute should return false (when listed on creation, appointing someone else now)
        ├── It execute should revert (when listed on creation, appointing someone else now)
        ├── It canExecute should return false (when currently appointed by a signer listed on creation)
        ├── It execute should revert (when currently appointed by a signer listed on creation)
        ├── It canExecute should return false (when unlisted on creation, unappointed now)
        └── It execute should revert (when unlisted on creation, unappointed now)
```

```
SignerListTest
├── When deploying the contract
│   └── It should disable the initializers
├── When cloning the contract
│   └── It should initialize normally
├── Given a deployed contract
│   └── It should refuse to initialize again
├── Given a new instance
│   └── Given calling initialize
│       ├── It should set the DAO address
│       ├── Given passing more addresses than supported on initialize
│       │   └── It should revert
│       ├── Given duplicate addresses on initialize
│       │   └── It should revert
│       ├── It should append the new addresses to the list
│       ├── It should return true on isListed
│       ├── It should emit the SignersAdded event
│       ├── It the encryption registry should be empty
│       └── It minSignerListLength should be zero
├── When calling updateSettings
│   ├── When updateSettings without the permission
│   │   └── It should revert
│   ├── When encryptionRegistry is not compatible
│   │   └── It should revert
│   ├── When minSignerListLength is bigger than the list size
│   │   └── It should revert
│   ├── It sets the new encryption registry
│   ├── It sets the new minSignerListLength
│   └── It should emit a SignerListSettingsUpdated event
├── When calling supportsInterface
│   ├── It does not support the empty interface
│   ├── It supports IERC165Upgradeable
│   ├── It supports Addresslist
│   └── It supports ISignerList
├── When calling addSigners
│   ├── When adding without the permission
│   │   └── It should revert
│   ├── Given passing more addresses than supported on addSigners
│   │   └── It should revert
│   ├── Given duplicate addresses on addSigners
│   │   └── It should revert
│   ├── Given unused addresses
│   │   └── It should remove the non signer addresses
│   ├── Given no unused addresses
│   │   └── It should keep the list as it is
│   ├── It should append the new addresses to the list
│   ├── It should return true on isListed
│   └── It should emit the SignersAdded event
├── When calling removeSigners
│   ├── When removing without the permission
│   │   └── It should revert
│   ├── When removing an unlisted address
│   │   └── It should revert
│   ├── Given removing too many addresses // The new list will be smaller than minSignerListLength
│   │   └── It should revert
│   ├── It should remove the given addresses
│   ├── It should return false on isListed
│   └── It should emit the SignersRemoved event
├── When calling isListed
│   ├── Given the member is listed
│   │   └── It returns true
│   └── Given the member is not listed
│       └── It returns false
├── When calling isListedAtBlock
│   ├── Given the member was listed
│   │   ├── Given the member is not listed now
│   │   │   └── It returns true
│   │   └── Given the member is listed now
│   │       └── It returns true
│   └── Given the member was not listed
│       ├── Given the member is delisted now
│       │   └── It returns false
│       └── Given the member is enlisted now
│           └── It returns false
├── When calling isListedOrAppointedByListed
│   ├── Given the caller is a listed signer
│   │   └── It listedOrAppointedByListed should be true
│   ├── Given the caller is appointed by a signer
│   │   └── It listedOrAppointedByListed should be true
│   └── Given the caller is not listed or appointed
│       └── It listedOrAppointedByListed should be false
├── When calling getListedEncryptionOwnerAtBlock
│   ├── Given the resolved owner is listed on getListedEncryptionOwnerAtBlock
│   │   ├── When the given address is the owner
│   │   │   └── It should return the given address
│   │   └── When the given address is appointed by the owner
│   │       └── It should return the resolved owner
│   ├── Given the resolved owner was listed on getListedEncryptionOwnerAtBlock
│   │   ├── When the given address is the owner 2
│   │   │   └── It should return the given address
│   │   └── When the given address is appointed by the owner 2
│   │       └── It should return the resolved owner
│   └── Given the resolved owner was not listed on getListedEncryptionOwnerAtBlock
│       └── It should return a zero value
├── When calling resolveEncryptionAccountAtBlock
│   ├── Given the resolved owner is listed on resolveEncryptionAccountAtBlock
│   │   ├── When the given address is owner
│   │   │   ├── It owner should be itself
│   │   │   └── It votingWallet should be the appointed address
│   │   └── When the given address is appointed
│   │       ├── It owner should be the resolved owner
│   │       └── It votingWallet should be the given address
│   ├── Given the resolved owner was listed on resolveEncryptionAccountAtBlock
│   │   ├── When the given address is owner 2
│   │   │   ├── It owner should be itself
│   │   │   └── It votingWallet should be the appointed address
│   │   └── When the given address is appointed 2
│   │       ├── It owner should be the resolved owner
│   │       └── It votingWallet should be the given address
│   └── Given the resolved owner was not listed on resolveEncryptionAccountAtBlock
│       ├── It should return a zero owner
│       └── It should return a zero appointedAgent
└── When calling getEncryptionAgents
    ├── Given the encryption registry has no accounts
    │   ├── It returns an empty list, even with signers
    │   └── It returns an empty list, without signers
    └── Given the encryption registry has accounts
        ├── Given no overlap between registry and signerList // Some are on the encryption registry only and some are on the signerList only
        │   └── It returns an empty list
        └── Given some addresses are registered everywhere
            ├── It returns a list containing the overlapping addresses
            ├── It the result has the correct resolved addresses // appointed wallets are present, not the owner
            ├── It result does not contain unregistered addresses
            ├── It result does not contain unlisted addresses
            └── It result does not contain non appointed addresses
```

