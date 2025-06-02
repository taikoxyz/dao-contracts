# Deployment list

## Mainnet
### May 13th, 2025
Deployed `SecurityCouncilDrill` at:
- `0x72B7dB404c4F11277A53081bF48580D6Bf4bC100`

### May 1st, 2025
Mainnet deployment using `.env.mainnet-deployment`
```
  Deploying from: 0x85f21919ed6046d7CE1F36a613eBA8f5EaC3d070
  Chain ID: 1
  Using production settings
  
  Factory: 0xEa53A99A2bb11a11c03Ef2A1CeD336c9B03908FF
  
  DAO: 0x9CDf589C941ee81D75F34d3755671d614f7cf261
  Voting token: 0x10dea67478c5F8C5E2D90e5E9B26dBe60c54d800
  Taiko Bridge: 0xd60247c6848B7Ca29eDdF63AA924E53dB6Ddd8EC
  
  Plugins
  - Multisig plugin: 0xD7dA1C25E915438720692bC55eb3a7170cA90321
  - Emergency multisig plugin: 0x2AffADEb2ef5e1F2a7F58964ee191F1e88317ECd
  - Optimistic token voting plugin: 0x989E348275b659d36f8751ea1c10D146211650BE
  
  Helpers
  - Signer list 0x0F95E6968EC1B28c794CF1aD99609431de5179c2
  - Encryption registry 0x2eFDb93a3B87b930E553d504db67Ee41c69C42d1
  - Delegation wall 0x402816c92f7F978C855190F367B3C21239efE692
  
  Plugin repositories
  - Multisig plugin repository: 0x2CBe2F0907F99B5d0bECF8Be9fF623B7214389C2
  - Emergency multisig plugin repository: 0x03Bfac9c11702ac9c239610a45ED58b80E82DA0b
  - Optimistic token voting plugin repository: 0x05960136abD6a3E87C67860C71859e91070735D1
```
## Holesky

### April 28th 2025
Reduced exit windows + SecurityCouncilDrill
```
      Deploying from: 0x4100a9B680B1Be1F10Cb8b5a57fE59eA77A8184e
  Chain ID: 17000
  Using production settings

  Factory: 0xd60C1C9e342B98f0eFeB98C80fA8634e0E350C97

  DAO: 0x05E0113B709e377a0882244B81a6B54f521c880f
  Voting token: 0x6490E12d480549D333499236fF2Ba6676C296011
  Taiko Bridge: 0xA098b76a3Dd499D3F6D58D8AcCaFC8efBFd06807

  Plugins
  - Multisig plugin: 0x41D8e598819e2ce231B0c562C96cbfAb91Cb87CC
  - Emergency multisig plugin: 0x5b27206ab2654125205077226196B5e3D4c38b94
  - Optimistic token voting plugin: 0x8bBDF344829191095Ee802499068316835f1e7a0

  Helpers
  - Signer list 0x1aDf6Fb3Df2870Ed415b87AAE7042c8882dAd0dE
  - Encryption registry 0x7b0dD81b32eF989dB3269FC94E4b363212CE2Be4
  - Delegation wall 0x3012aEff25F2d6F5c160bEdABfF99D7ed15A5537

  Plugin repositories
  - Multisig plugin repository: 0xa9b945ef3593B13dfd9B31571fB0Aa58fe3D43DB
  - Emergency multisig plugin repository: 0x304F5D51FF9B5988cbDD51cf817d76D1Ce316Ffc
  - Optimistic token voting plugin repository: 0x85E30Ae914E2fae3f511974d056cdaB68E55532b

Deployed SecurityCouncilDrill at: 0x2d13dc3A1aB2AfFD21239d33b1306b6f463aE751

```
### December 5th 2024

Deployment for internal testing:
- Exit window of 10 minutes (parameterizable)
- L2 disabled
- Using a pre-release voting token

```
  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Chain ID: 17000
  Using test token settings
  Minting test tokens for the multisig members and the bridge

  Factory: 0x5Ecd6635598ea0E15Ce1Adc2681542872fB046B3

  DAO: 0x9911fB2aa1E18b2E95dB84EDEaCe80e1FaB403a3
  Voting token: 0x257fB8b988D0af2ceC5B599b867E3B833D2C0F92
  Taiko Bridge: 0x0000000000000000000000000000001234567890

  Plugins
  - Multisig plugin: 0x757a214760f28e24cC14e61A89eB4eeE2E039654
  - Emergency multisig plugin: 0x1146159D19A25a5b092F2BEbb19841bCda4A62Db
  - Optimistic token voting plugin: 0xE5D346143aCDFCE5A2f0663cbD762d456d429E3a

  Helpers
  - Signer list 0x8C4211DF1d32785117f12b84b68C5A60980857Ab
  - Encryption registry 0xE8b63e29D3eC1fbF5032d298DD8CC2C5d42C1a27
  - Delegation wall 0x979A1a38cC0036E4E605747b20B2b3661B2ed07C

  Plugin repositories
  - Multisig plugin repository: 0xc08fBb91988D63b716e6074abfDC42c050BD4Fb4
  - Emergency multisig plugin repository: 0xAa141C988DDB51b7c72C1253ae2a75A3065a4369
  - Optimistic token voting plugin repository: 0x6d234bcE7739A0F3316c4aD9e7524e1dBC5806CF
```

### November 28th 2024

Deployment for internal testing:
- Exit window of 7 days (parameterizable)
- L2 disabled
- Using a pre-release voting token

```

  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Chain ID: 17000
  Using test token settings
  Minting test tokens for the multisig members and the bridge

  Factory: 0x7b9B81258d4b52Fb6D4Fb3C597bCeD2652F00bc8

  DAO: 0x9Fe7b040cfD4CA67BB44714aa9c9D2F5234780BE
  Voting token: 0x690b92470Aa1500CFc64af5adAb4A9D4c0a0a5f0
  Taiko Bridge: 0x0000000000000000000000000000001234567890

  Plugins
  - Multisig plugin: 0xEAfaB9a95dC75C51d94b2cad2D675296914fA8a6
  - Emergency multisig plugin: 0xF0847b600eebe43da7FD6bA1C9E325EC8408cB4F
  - Optimistic token voting plugin: 0x892d99d271844A7C39757adcD177fbE2EFD3adbb

  Helpers
  - Signer list 0x08e2003Aab54d8C981A3bc5c48bB121B9eb57467
  - Encryption registry 0x5Ec236003Cf8493cF2621E5daCAbD60f0a7A31Ae
  - Delegation wall 0xe2e3b8a20048F699d40c1d4394BE62B30560fa6f

  Plugin repositories
  - Multisig plugin repository: 0xe797aFeABf9Cf5a0e86EA2B5D3a5F20397A98514
  - Emergency multisig plugin repository: 0x87322002988a7AD7864cF89233b43D7CAE9289DA
  - Optimistic token voting plugin repository: 0x2a0fa7CBB75444DA374169e9dd6Fee3330082B99
```

### November 18th 2024

Deployment for internal testing:
- Exit window of 7 days
- L2 disabled
- Using a pre-release voting token

Deployment with the encryption registry available

```
  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Chain ID: 17000
  Using test token settings
  Minting test tokens for the multisig members and the bridge

  Factory: 0x7D3dA38E856f002f4623B0D32a494E358f72adC9

  DAO: 0x8caD8b62769710233f319611d064462b633Bbb8C
  Voting token: 0x18EE0C13EC97a60fc190bABB348FD87421368920
  Taiko Bridge: 0x0000000000000000000000000000001234567890

  Plugins
  - Multisig plugin: 0xc880dB28A9105e6D69d30E93d99E38eFE84c54CB
  - Emergency multisig plugin: 0x3bE6294EB67A3501bF091fD229282F2A51c532d2
  - Optimistic token voting plugin: 0xBB249c027c5De908288104F665A605ceC88ad6CE

  Helpers
  - Signer list 0x7716DcB9B83f5f9fB5266767841c3F29555cE2d5
  - Encryption registry 0x94224B656D7D174B2Aa97FFCB188A847E6EA4511
  - Delegation wall 0xb8D78b40014D36F83dDc8219c0621d35E8043167

  Plugin repositories
  - Multisig plugin repository: 0x2d870FCedF2C1204839C3b8bca2Bf6e632b4E602
  - Emergency multisig plugin repository: 0xe069Ae1DCB19A9DE9C516097FaC20ea070311D48
  - Optimistic token voting plugin repository: 0xd774b0976C67832C84848dC6fdadE6189B297A71
```

### October 16th 2024

Deployment for internal testing:
- Exit window of 2h
- L2 disabled
- Using a pre-release voting token

```
Chain ID: 17000
Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
Using production settings

Factory: 0xFC84a8516Cc08F7cAB9633C900eB7E54811533Cd

DAO: 0x7A1a8393678cFB7C72d9C3Ed0Db69F7A336224b7
Voting token: 0x7dbcF74e44EFc5eC635f40c962d90F2EeD81069a
Taiko Bridge: 0xA098b76a3Dd499D3F6D58D8AcCaFC8efBFd06807

Plugins
- Multisig plugin: 0x3952b0de6537866d872331d529357C23427cf364
- Emergency multisig plugin: 0x38aC34F55A0712C101697360118fEC35AeC777C9
- Optimistic token voting plugin: 0xd0E3fC86DD0AdA97aC2a3432b75BE31b0e1E900F

Plugin repositories
- Multisig plugin repository: 0xa77DDA30b1a0AbAa837212C458C46a1Ae8a60Cc6
- Emergency multisig plugin repository: 0x875A8BBac6880c965844f4d3935fD892C8f3F931
- Optimistic token voting plugin repository: 0xF03e700D8C08c8c50BB5e7C7165342858172E65a

Helpers
- Encryption registry 0xD0D409d0048F998fb58a6b352Cf58239c5168d53
- Delegation wall 0x0470d887b19cf877949A5Bc227042DFfAa3d7752
```

### August 1st 2024

Deployment for internal testing, with L2 voting disabled and using a pre-release voting token.

```
  Chain ID: 17000
  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Using production settings

  Factory: 0xC06F1a08fBacF5895aDe3EFB137Dc2Cc2dA7b3B9

  DAO: 0xC38fFd23688cF6f70b61C7FD6ca6D7D2C84Ef252
  Voting token: 0x7dbcF74e44EFc5eC635f40c962d90F2EeD81069a
  Taiko Bridge: 0xA098b76a3Dd499D3F6D58D8AcCaFC8efBFd06807

  Plugins
  - Multisig plugin: 0x038FdE3344EfFe37A4575cA1276f1982A43ce9dF
  - Emergency multisig plugin: 0x0fC611670228A61824c317926f30e8a2615aa1A3
  - Optimistic token voting plugin: 0x619d6661eA06b917e26694f23c5Bb32fa0456773

  Plugin repositories
  - Multisig plugin repository: 0xcba5780F2054BB9FAEA4f55047bdcD5828704829
  - Emergency multisig plugin repository: 0x175749Dec3157ADFf45D20abF61F8Cf9c17D16Af
  - Optimistic token voting plugin repository: 0x8D762BdEb9582b782D2955C3C6701Fc1a89fe8FD

  Helpers
  - Public key registry 0x9695520e32F85eF403f6B18b8a94e44A90D5cBF0
  - Delegation wall 0x15B379C5c9115e645Cdf1EF9fA03389586AfEa2A
```

### July 29th 2024

Deployment for internal testing, with L2 voting disabled and using a test voting token.

```
  Chain ID: 17000
  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Using internal testing settings
  Minting test tokens for the multisig members and the bridge

  Factory: 0xF9Be929F990F9C8bF9ed355Ddd29Af7bd9995890

  DAO: 0xeB4586617089270Fe042F69Bf799590AF224807a
  Voting token: 0x12b2574840dB17C2278d9725a2679E97FE266075
  Taiko Bridge: 0x0000000000000000000000000000001234567890

  Plugins
  - Multisig plugin: 0xd8Fe1194Cf90eF38b54A110EcfeAE8F2AA5Dfe86
  - Emergency multisig plugin: 0xeCBa720A8645B198b2637f6559B9155E4bc3B566
  - Optimistic token voting plugin: 0xd9F6A2533efab98bA016Cb1D3001b6Ec1C246485

  Plugin repositories
  - Multisig plugin repository: 0xa51B2d7b7847cFB666919301e03f48b596A15871
  - Emergency multisig plugin repository: 0x2ce4e91D1a00c42736730B494Ab9BFfbfEDdF2ac
  - Optimistic token voting plugin repository: 0xC8f84E6E05b9C7b631A4dFD092605b8884207868

  Helpers
  - Public key registry 0x9695520e32F85eF403f6B18b8a94e44A90D5cBF0
  - Delegation wall 0x15B379C5c9115e645Cdf1EF9fA03389586AfEa2A
```

### July 25th 2024

Deployment for internal testing, targeting test dependencies.

```
  Chain ID: 17000
  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Using internal testing settings
  Minting test tokens for the multisig members and the bridge

  Factory: 0x151dB38A460F3c4F9F377cf040A5Ed5D9958940D

  DAO: 0x192206aA5807ADef5C6C32ffBA2C6dA8e4473e9e
  Voting token: 0xA8888c98205B146804798B4dA1411288B5E8bb1C
  Taiko Bridge: 0x0000000000000000000000000000001234567890

  Plugins
  - Multisig plugin: 0xd3e68dB8B60120D79032E8eb84c620CE6D9D6258
  - Emergency multisig plugin: 0x155f75684Ed220D78634432F892D61b8B7D592B5
  - Optimistic token voting plugin: 0x4f438847492002FF84B3735e1da8E65fADD18271

  Plugin repositories
  - Multisig plugin repository: 0xC16d70743046b3478728eE22Ca3110515Fa05718
  - Emergency multisig plugin repository: 0x20235f476181a8C3b5121e36EAb13e4Bf6A65cD4
  - Optimistic token voting plugin repository: 0xa03ef51E9cCBe245BF2A7bF431eE0A81908d1e84

  Helpers
  - Public key registry 0xB96057cC9A2bb13C837d88d10370A804Efe68396
  - Delegation wall 0xE1A79CCd6d5Dda5dCfCC4B2aaCfE458A82B2F914
```


### July 18th 2024

Deployment for internal testing. Targetting Taiko's deployment.

```
  Chain ID: 17000
  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Using production settings

  Factory: 0x30435F686dA174f5B646E75684A0795F6A06d0C8

  DAO: 0xcB10AB2E59Ac73e202adE31531462F7a75cfe74C
  Voting token: 0x6490E12d480549D333499236fF2Ba6676C296011
  Taiko Bridge: 0xA098b76a3Dd499D3F6D58D8AcCaFC8efBFd06807

  Plugins
  - Multisig plugin: 0x9d2f62109CE2fDb3FaE58f14D2c1CedFdc7939f9
  - Emergency multisig plugin: 0x2198F07F02b2D7365C7Df8C488741B43EE076f83
  - Optimistic token voting plugin: 0x799A3D93DB762A838F41Dd956857463AC9D245d7

  Plugin repositories
  - Multisig plugin repository: 0xA16B5FD427EA11f171104945B6360793C801766B
  - Emergency multisig plugin repository: 0x5644C0B88a571B35C0AaA2F9378A06F60f04A927
  - Optimistic token voting plugin repository: 0x48309dCFc32eBB1CB6DbA9169F8259f35d4fE993

  Helpers
  - Public key registry 0x054098E107FCd07d1C3D0F97Ba8217CE85AaC3ca
  - Delegation wall 0x9A118b78dE4b3c91706f45Bb8686f678d5600500
```

### July 9th 2024

Deployment intended for staging purposes.

```
  Chain ID: 17000
  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Minting test tokens for the multisig members and the bridge

  Factory: 0x2799EBD75fA793b93c4feBdb134b3b6Cbbb32124

  DAO: 0xa0FDC6b2bf9FFd48D4F86b697761F13b32D0b7A1
  Voting token: 0x01aeE1a16C8807DF52f2DA9191Cec8058e747F4A
  Taiko Bridge: 0x0000000000000000000000000000001234567890

  Plugins
  - Multisig plugin: 0x284F47A42f1Eb96f0F1540931F8Ef04F4243Fb33
  - Emergency multisig plugin: 0x0E09bFDA087cf60Bd03A767A03bf88e9E3824c39
  - Optimistic token voting plugin: 0xf52B4681F1eB88C5b028510a3F365b5d04fa3295

  Plugin repositories
  - Multisig plugin repository: 0x00fD4E0093a885F20208308C996461dbD93d3604
  - Emergency multisig plugin repository: 0xb17469b843Ec56Bd75b118b461C07BA520f792d1
  - Optimistic token voting plugin repository: 0xd49028E41E941296A48e5b1733bBDA857509FD1b

  Helpers
  - Public key registry 0x3b1a9c9198eF98d987A6361219FC59c3F805537d
  - Delegation wall 0xfdFd89FA33B92Cd1c49A2Ae452294Bc2C89f810D


```

### July 4th 2024
Used for internal development, using a different Taiko Bridge address.

```
  Chain ID: 17000
  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Minting test tokens for the multisig members and the bridge

  Factory contract: 0x57B11BfBEEc6935b307abF8a9c8Ce0DE8DB1868C

  DAO contract: 0xfCb5AC35C8Ab27c8f6B277a2963e7352f71ca993
  Voting token: 0xD2275fEdcE5defbCccA4C29EE058455288248F84
  Taiko Bridge: 0x0000000000000000000000000000001234567890

  - Multisig plugin: 0x9cBDcae87CBE9bdbb9A882A551F4A3F20D007033
  - Emergency multisig plugin: 0x456349f1F6621604536E99dB591EBD94e00d94F6
  - Optimistic token voting plugin: 0xF9b68bD4a57281f3Ae8FE9A4600BD516fc7938c5

  - Multisig plugin repository: 0xF5625F767D06814Becd2e4d224629dBA589c905E
  - Emergency multisig plugin repository: 0x920adce1a42A07E6A167A39a94194739e7602e55
  - Optimistic token voting plugin repository: 0xd26d960b2BbfD0efcC16659f804A636c6B46bBce

  Helpers:
  - Public key registry 0x71D886c82694828f223136d6db18A3603ed8110e
  - Delegation wall 0xdeb0377b711DbA11d4f6B90EC2153256B8E17fd8
```

### July 3rd 2024
Used for internal development.

```
  Chain ID: 17000

  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Minting test tokens for the multisig members and the bridge
  Test voting token: 0x53bbA0e878a73013AA0B1Dc6e6c4ea9691182E04
  Factory contract: 0x06D323915f7057e32B0560b95A298c5a2Fe80C8d

  DAO contract: 0xC373851C8a42D0c9120f5bd6c218693CFED068C1

  - Multisig plugin: 0x754C929002d09d09610831F81263Bb5A43Ea0865
  - Emergency multisig plugin: 0x21B1eeb7A9ff58e4422eB2a06A8b2b2ceb0aC581
  - Optimistic token voting plugin: 0x14DCBE5aAF3Ce2998E93f98DcFAB1cbd198D1257

  - Multisig plugin repository: 0x494d47d419c2b48e3f888066FAf210DD32BFA1b6
  - Emergency multisig plugin repository: 0xcA7404c1dDD5cb817E94F970256972b277F82f80
  - Optimistic token voting plugin repository: 0xAe66318a5941712A80eA7B6e2F96C23B071816E5

  Public key registry 0x683C6B9c550870423cEc58f6cedd78BCE36Fd7f1
  Delegation wall 0x291aAE5fCAbBbD19A1b64F93338B71343E2AD740
```

### July 1st 2024
Used as a staging deployment.

```
  Chain ID: 17000

  Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
  Minting test tokens for the multisig members and the bridge
  Test voting token: 0xa95BADd91beB92F364905187eCB08B80220d5FA3
  Factory contract: 0xFbA94606d10e807Bf6542C19a68DfEa815a4eeC3

  DAO contract: 0xdA69Bd97278c409574AdC39295465A848C82CD16

  - Multisig plugin: 0x2a22Fc29dE8944E62227bf75C89cA2e8CE9BA274
  - Emergency multisig plugin: 0x7C36a0F03c27880C23f5704296Bc18Bfc33A7f59
  - Optimistic token voting plugin: 0x40CD85d43B883C83290ed5D18400C640176A9679

  - Multisig plugin repository: 0x307d009483C1b8Ef3C91F6ae748385Bf0936C59e
  - Emergency multisig plugin repository: 0x8181da2e9b1a428a4cF60fF6CEFc0098c1298aaA
  - Optimistic token voting plugin repository: 0x0847F2531e070353297fc3D7fFDB4656C1664c6d

  Public key registry 0x7A9577A02608446022F52984435ce1ca632BA629
  Delegation wall 0xE917426E10a54FbF22FDAF32A4151c90550e1cA5
```

## Sepolia

### June 13th 2024

```
Chain ID: 11155111

Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
Test voting token: 0xf7A8F99a1d0AFB3C95f80770223b00e062C6Ec19
Factory contract: 0x8c99CDb5567206660CA9b77C3B26C13F6C674952

DAO contract: 0x6C477915CC803518723d4Bdd5B2170cf38A57203

- Multisig plugin: 0x0fC611670228A61824c317926f30e8a2615aa1A3
- Emergency multisig plugin: 0x619d6661eA06b917e26694f23c5Bb32fa0456773
- Optimistic token voting plugin: 0xC9304930f6a4fB2DAe74A17032426Aa1E817897A

- Multisig plugin repository: 0x841E3dA30697C8FC7224a43952041001545a2443
- Emergency multisig plugin repository: 0x6E8578B1519a04BA9262CB633B06624f636D4795
- Optimistic token voting plugin repository: 0x58CA6f90edB98f9213353f456c685ABF253edAA7

Public key registry 0xadAb459A189AAaa17D4807805e6Fab55d3fb5C44
Delegation wall 0x0cE7f031BA69abFB404fE148dD09F597db8AB3a0
```

On June 6th:

```
Chain ID: 11155111

Deploying from: 0x424797Ed6d902E17b9180BFcEF452658e148e0Ab
Test voting token: 0x7Ae1BbFfF99316922cebC74C9465d8E3Cdfc65e3
Factory contract: 0x8793E7847d4a522aE3b76b2F05AD48C390b079A6

DAO contract: 0x464E808De86C90Ea0423854cABE887b6AEF85c1E

- Multisig plugin: 0x07d0ac4ef82cA8E799BAB1f07f5e4f1De933E88C
- Emergency multisig plugin: 0x143209C5fc8004c4B41cA7Bd27666d884B35c809
- Optimistic token voting plugin: 0x73aA4dBD85eca05542013dcd893CC9DD0c681184

- Multisig plugin repository: 0xA3E9182048AE97ABd2AF3045d7690Ea87B44beAF
- Emergency multisig plugin repository: 0x1cF2c1A6075B532df0E9CEA2734AF526Ff058B19
- Optimistic token voting plugin repository: 0x44Bf21d7d7d052b67A98C924617583f8EBC8a5bC

Public key registry 0xD4615654030982779AC1DD0ff3e69FCD8f8b702d
Delegation wall 0x32ccaee7288e43128C99B5505e6B9cF395ED8b64
```
