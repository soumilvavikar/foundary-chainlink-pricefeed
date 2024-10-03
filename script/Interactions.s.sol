// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import {Script, console} from "lib/forge-std/src/Script.sol";
import {PriceFeed} from "../src/PriceFeed.sol";
// Importing the DevOpsTools
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

/**
 * @title This contract will contain the interaction for eth to usd price feed in the PriceFeed contract
 * @author Soumil Vavikar
 * @notice NA
 */
contract EthToUsdPriceFeedInteractions is Script {
    function ethToUsdPriceFeed(address contractAddress) public view {
        uint256 ethToUsd = PriceFeed(contractAddress).getETHUSD();

        console.log("ETH to USD Price: %s", ethToUsd);
    }

    function run() external view {
        // Get the most recently deployed contract
        address mostRecentContract = DevOpsTools.get_most_recent_deployment(
            "PriceFeed",
            block.chainid
        );

        // Calling the ethToUsdPriceFeed method
        ethToUsdPriceFeed(mostRecentContract);
    }
}

/**
 * @title This contract will contain the interaction for link to usd price feed in the PriceFeed contract
 * @author Soumil Vavikar
 * @notice NA
 */
contract LinkToUsdPriceFeedInteractions is Script {
    function linkToUsdPriceFeed(address contractAddress) public view {
        uint256 ethToUsd = PriceFeed(contractAddress).getLINKUSD();

        console.log("LINK to USD Price: %s", ethToUsd);
    }

    function run() external view {
        // Get the most recently deployed contract
        address mostRecentContract = DevOpsTools.get_most_recent_deployment(
            "PriceFeed",
            block.chainid
        );

        // Calling the ethToUsdPriceFeed method
        linkToUsdPriceFeed(mostRecentContract);
    }
}
