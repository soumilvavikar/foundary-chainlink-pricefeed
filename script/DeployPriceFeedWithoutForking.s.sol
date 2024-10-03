// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import {Script} from "lib/forge-std/src/Script.sol";
import {PriceFeed} from "../src/PriceFeed.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

/**
 * @title This contract will help us deploy the PriceFeed contract without forking
 * @author Soumil Vavikar
 * @notice NA
 */
contract DeployPriceFeedWithoutForking is Script {
    function run() external returns (PriceFeed) {
        // This variable will help enable forked calls in local anvil instance.
        bool forkingEnabled = false;
        HelperConfig helperConfig = new HelperConfig(forkingEnabled);

        (address ethUsdPriceFeed, address linkUsdPriceFeed) = helperConfig
            .activeNetworkConfig();

        vm.startBroadcast();

        PriceFeed priceFeed = new PriceFeed(ethUsdPriceFeed, linkUsdPriceFeed);

        vm.stopBroadcast();

        return priceFeed;
    }
}
