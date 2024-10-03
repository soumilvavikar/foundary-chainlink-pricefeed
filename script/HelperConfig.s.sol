// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockAggregatorV3Interface.sol";

/**
 * @title Helper Config for Deployments
 *  - This will be used to deploy Mocks when we are on local anvil chain
 *  - Keep track of contract addresses across different chains
 * @author Soumil Vavikar
 * @notice NA
 */
contract HelperConfig is Script {
    /**
     * This struct will hold all the network configs required for the smart contract to function as needed.
     */
    struct NetworkConfig {
        // ETH USD Price Feed Address
        address ethUsdPriceFeed;
        // LINK USD Price Feed Address
        address linkUsdPriceFeed;
    }

    // Constant for decimals
    uint8 public constant DECIMALS = 8;
    // Constant for initial price
    int256 public constant INITIAL_PRICE = 2000e8; // Constant for initial price
    int256 public constant INITIAL_PRICE_LINK = 1100e8;
    // Constant for sepolia chain id
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    // Constant for Ethereum Mainnet
    uint8 public constant MAINNET_CHAIN_ID = 1;

    /**
     * This object will hold the active network configurations
     */
    NetworkConfig public activeNetworkConfig;
    // Variable to enable/disable forking
    bool s_forkingEnabled;

    /**
     * Constructor to setup the activeNetworkConfig object
     */
    constructor(bool forkingEnabled) {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaETHConfig();
        } else if (block.chainid == MAINNET_CHAIN_ID) {
            activeNetworkConfig = getMainnetETHConfig();
        } else {
            s_forkingEnabled = forkingEnabled;
            activeNetworkConfig = createOrGetAnvilETHConfig();
        }
    }

    /**
     * This function will setup the network configurations for sepolia test net
     */
    function getSepoliaETHConfig() public pure returns (NetworkConfig memory) {
        // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306 >> fetched from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1 for Seplia Testnet
        address ethUsdPriceFeedAdd = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        // Address 0xc59E3633BAAC79493d908e63626716e204A45EdF >> fetched from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1 for Seplia Testnet
        address linkUsdPriceFeedAdd = 0xc59E3633BAAC79493d908e63626716e204A45EdF;

        NetworkConfig memory sepoliaConfig = NetworkConfig({
            ethUsdPriceFeed: ethUsdPriceFeedAdd,
            linkUsdPriceFeed: linkUsdPriceFeedAdd
        });

        return sepoliaConfig;
    }

    /**
     * This function will setup the network configurations for Ethereum main net
     */
    function getMainnetETHConfig() public pure returns (NetworkConfig memory) {
        // Address: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 >> fetched from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1 for Etherium Mainnet
        address ethUsdPriceFeedAdd = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
        // Address: 0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c >> fetched from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
        address linkUsdPriceFeedAdd = 0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c;

        NetworkConfig memory ethConfig = NetworkConfig({
            ethUsdPriceFeed: ethUsdPriceFeedAdd,
            linkUsdPriceFeed: linkUsdPriceFeedAdd
        });

        return ethConfig;
    }

    /**
     * This function will setup the network configurations for local anvil chain
     *  - Here we will deploy the mocks
     *  - Return the mock contracts address
     */
    function createOrGetAnvilETHConfig() public returns (NetworkConfig memory) {
        // If the address for priceFeed !=0, i.e. its created already, we should return that and not re-create it
        if (
            activeNetworkConfig.ethUsdPriceFeed != address(0) &&
            activeNetworkConfig.linkUsdPriceFeed != address(0)
        ) {
            return activeNetworkConfig;
        }

        if (s_forkingEnabled) {
            /**
             * IMPORTANT:::: As we will fork of Sepolia TestNet - We are mentioning the Sepolia testnet addresses of the price feeds.
             */
            // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306 >> fetched from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1 for Seplia Testnet
            address ethUsdPriceFeedAdd = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
            // Address 0xc59E3633BAAC79493d908e63626716e204A45EdF >> fetched from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1 for Seplia Testnet
            address linkUsdPriceFeedAdd = 0xc59E3633BAAC79493d908e63626716e204A45EdF;

            NetworkConfig memory sepoliaConfig = NetworkConfig({
                ethUsdPriceFeed: ethUsdPriceFeedAdd,
                linkUsdPriceFeed: linkUsdPriceFeedAdd
            });

            return sepoliaConfig;
        } else {
            vm.startBroadcast();
            MockV3Aggregator mockEthUsdPriceFeed = new MockV3Aggregator(
                DECIMALS,
                INITIAL_PRICE
            );

            MockV3Aggregator mockLinkUsdPriceFeed = new MockV3Aggregator(
                DECIMALS,
                INITIAL_PRICE_LINK
            );
            vm.stopBroadcast();

            NetworkConfig memory anvilConfig = NetworkConfig({
                ethUsdPriceFeed: address(mockEthUsdPriceFeed),
                linkUsdPriceFeed: address(mockLinkUsdPriceFeed)
            });
            return anvilConfig;
        }
    }
}
