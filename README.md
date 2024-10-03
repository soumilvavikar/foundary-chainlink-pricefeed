# Foundry Project for Interacting with ChainLink PriceFeed

## Check Your Foundry Version is Up to Date

```shell
#Check foundry versions
forge --version
anvil --version
cast --version
chisel --version

# Update the foundry to the latest version
foundryup
```

## Setup Stage - Initialize the Foundry Project

```shell
# This command will initialize the project folder
forge init

# Cleanup the default contract, test, and script files.
```

## Development Stage - Build Your Contract and Deployment Scripts

### Develop the Contract

- Write the contract to connect to the ChainkLink's PriceFeed Oracle. Check the code in the `PriceFeed.sol` file.
  - We will need to install the latest libraries for the chainlink contracts in the workspace. Use the following command
  - Once the install process is complete, update the `foundry.toml` file's remapping section.

```shell
forge install smartcontractkit/chainlink-brownie-contracts@1.2.0 --no-commit
```

- Write the deployment script and helper config for the deployment script.
  - Check the code in the `DeployPriceFeed.s.sol` and `HelperConfig.s.sol`.
  - For local deployment, we can choose one of the options (we have coded for both, look for `forkingEnabled` flag in the `DeployPriceFeed.s.sol` and how it is being used in the `HelperConfig.s.sol`):
    - Forking the testnet / mainnet
    - Mocking the ChainLink PriceFeed contract
      - Look at the `test/mocks/MockAggregatorV3Interface.sol`

### Unit Testing

Check the `TestPriceFeed.t.sol` for how the unit testing is being done. We have leveraged the mocked instance of the AggregatorV3Interface.

Commands:

```shell
# To run all the tests in the project (Use --mt <method-name> if you want to test a particular method)
forge test
# To run the code coverage
forge coverage

```

## Deployment Stage - To Local Anvil Chain

### .env File Setup

Setup the `.env` file with the API_KEYS and URLs. Refer to the `.env.sample` file.

- For this project, we need to define:
  - PRIVATE_KEY
    - The test account's private key
    - It can be found in logs when local anvil chain is started
  - RPC_URL
    - The endpoint to connect to the local anvil chain
    - Value: <http://127.0.0.1:8545>
  - INFURA_RPC_URL
    - It should look like: <https://sepolia.infura.io/v3/INFURA_API_KEY>
    - Replace the INFURA_API_KEY with actual API KEY
    - This property will be used for forking the testnet on local anvil chain
  - FORKED_BLOCK_NUMBER
    - This will be the block number we need to fork from on our local chain
    - Sample value: 6800249
  - SEPOLIA_RPC_URL
    - Optional
    - This will be needed ONLY if you decide to deploy the contract to testnet and test it.

Once the `.env` file is setup. Run the following command to ensure the environment properties are available for use.

```shell
source .env
```

### Spin Up the Local Anvil Chain

#### Command for spinning a forked (from TestNet from a particular block number) local anvil chain

**NOTE**: Ensure that the `forkingEnabled` flag is set to true in the `DeployPriceFeed.s.sol` file. Or else we won't leverage the forked instance.

```shell
anvil --fork-url $INFURA_RPC_URL --fork-block-number $FORKED_BLOCK_NUMBER
```

#### Command for spinning local anvil chain without forking

**NOTE**: This will leverage the mocked instance of the AggregatorV3Interface.sol.

```shell
anvil
```

### Deploy the PriceFeed Contract on the Local Anvil Chain

**NOTE**: At this point, it doesn't matter if the anvil chain is forked or not.

```shell
# This command will compile and confirm if the contract can be deployed successfully or not
forge script script/DeployPriceFeed.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY

# Adding --broadcast to the above command, deploy the contract on the chain
forge script script/DeployPriceFeed.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

At this point, we have successfully deployed our contract to the local anvil chain. Next step would be to test the contract.

### Test the Deployed Contract

#### Write the `Interactions.s.sol`

`Interactions.s.sol` contains the logic for interacting with the latest version of the deployed contract.

- We have used the `foundry-devops` package in the `Interactions.s.sol`
- To import `foundry-devops` that in the project, use the below command

```shell
# For interactions - we need foundry-devops
forge install Cyfrin/foundry-devops --no-commit
```

Once the `Interactions.s.sol` script is ready, we can execute it using the following command

```shell
forge script script/Interactions.s.sol --tc EthToUsdPriceFeedInteractions --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast

forge script script/Interactions.s.sol --tc LinkToUsdPriceFeedInteractions --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
# Whenever we want to have a newly created forked blockchain whenever you test, you can use --fork-url and --fork-block-number instead of --rpc-url
```
