// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

// Importing AggregatorV3Interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// Importing console
import {console} from "forge-std/console.sol";

/**
 * @title PriceFeed Contract - This will get PriceFeed information for ETH to USD and LINK to USD from ChainLink Pricefeed Oracle.
 * @author Soumil Vavikar
 * @notice NA
 */
contract PriceFeed {
    // Defining AggregatorV3Interface
    AggregatorV3Interface s_ethToUsdPriceFeed;
    AggregatorV3Interface s_linkToUsdPriceFeed;

    // Defining a constructor
    constructor(address ethToUsdPriceFeed, address linkToUsdPriceFeed) {
        s_ethToUsdPriceFeed = AggregatorV3Interface(ethToUsdPriceFeed);
        s_linkToUsdPriceFeed = AggregatorV3Interface(linkToUsdPriceFeed);
    }

    /**
     * This function helps us get the price from the AggregatorV3Interface
     */
    function getETHUSD() public view returns (uint256) {
        //(uint80 roundId, int256 price, uint256 startedAt, uint256 finishedAt, uint80 answeredInRound) = s_ethToUsdPriceFeed.latestRoundData();
        (, int256 price, , , ) = s_ethToUsdPriceFeed.latestRoundData();
        // This price variable will return the price of ETH in terms of USD

        uint256 ethUsdPrice = uint256(price) * 1e10;
        console.log("(In Contract) ETH to USD price:", ethUsdPrice);
        return ethUsdPrice;
    }

    /**
     * This function helps us get the price from the AggregatorV3Interface
     */
    function getLINKUSD() public view returns (uint256) {
        //(uint80 roundId, int256 price, uint256 startedAt, uint256 finishedAt, uint80 answeredInRound) = s_linkToUsdPriceFeed.latestRoundData();
        (, int256 price, , , ) = s_linkToUsdPriceFeed.latestRoundData();
        // This price variable will return the price of LINK in terms of USD

        uint256 linkUsdPrice = uint256(price) * 1e10;
        console.log("(In Contract) LINK to USD price:", linkUsdPrice);
        return linkUsdPrice;
    }
}
