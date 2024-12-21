//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BelovedCat} from "../src/BelovedCat.sol";
import {console2} from "forge-std/console2.sol";
import {Script} from "forge-std/Script.sol";
import {DeployBelovedCat} from "./DeployBelovedCat.s.sol";

contract Interactions is Script {
    BelovedCat public belovedCat;
    DeployBelovedCat deployer = new DeployBelovedCat();

    function run() public {
        belovedCat = deployer.run();
        mint_change_and_gettokenURI();
    }

    function mint_change_and_gettokenURI() public returns (string memory metadata1, string memory metadata2) {
        vm.startBroadcast(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        belovedCat.mint();
        belovedCat.mint();
        belovedCat.changeBelovedCat(1);
        metadata1 = belovedCat.tokenURI(0);
        metadata2 = belovedCat.tokenURI(1);
        vm.stopBroadcast();
    }
}
