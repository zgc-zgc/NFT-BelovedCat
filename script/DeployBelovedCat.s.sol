// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BelovedCat} from "../src/BelovedCat.sol";
import {Script} from "forge-std/Script.sol";

contract DeployBelovedCat is Script {
    BelovedCat public belovedCat;

    function run() external returns (BelovedCat) {
        belovedCat = deployBelovedCat();
        return belovedCat;
    }

    function deployBelovedCat() internal returns (BelovedCat) {
        vm.startBroadcast();
        belovedCat = new BelovedCat();
        vm.stopBroadcast();
        return belovedCat;
    }
}
