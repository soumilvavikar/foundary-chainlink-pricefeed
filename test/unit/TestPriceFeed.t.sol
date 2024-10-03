// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {PriceFeed} from "../../src/PriceFeed.sol";
import {DeployPriceFeedWithoutForking} from "../../script/DeployPriceFeedWithoutForking.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

/**
 * @title FundMeTest as test class to test the functions in the PriceFeed contract
 * @author Soumil Vavikar
 * @notice NA
 */
contract PriceFeedTest is Test {
    PriceFeed priceFeed;

    address public constant USER = address(1);

    function setUp() external {
        DeployPriceFeedWithoutForking deployPriceFeed = new DeployPriceFeedWithoutForking();
        priceFeed = deployPriceFeed.run();
    }

    function testGetETHUSD() public {
        // prank helps us send the sender of the call as we set
        // This only works in tests and in foundry
        vm.startPrank(USER);
        uint256 ethToUsd = priceFeed.getETHUSD();
        // Stop prank whenever we don't have the need for it in the next steps.
        vm.stopPrank();
        assertEq(2000000000000000000000, ethToUsd);
    }

    function testGetLINKUSD() public {
        // prank helps us send the sender of the call as we set
        // This only works in tests and in foundry
        vm.startPrank(USER);
        uint256 linkToUsd = priceFeed.getLINKUSD();
        // Stop prank whenever we don't have the need for it in the next steps.
        vm.stopPrank();
        assertEq(1100000000000000000000, linkToUsd);
    }
}
