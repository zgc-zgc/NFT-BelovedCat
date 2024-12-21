//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BelovedCat} from "../src/BelovedCat.sol";
import {Script, console2} from "forge-std/Script.sol";
import {DeployBelovedCat} from "./DeployBelovedCat.s.sol";
import {DevOpsTools} from "@foundry-devops/src/DevOpsTools.sol";

contract Interactions is Script {
    address mostRencetlyDeployed = DevOpsTools.get_most_recent_deployment("BelovedCat", block.chainid);
    BelovedCat belovedCat = BelovedCat(mostRencetlyDeployed);
    address anvil_user = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function mint_change_and_gettokenURI() public {
        vm.startBroadcast(anvil_user);
        belovedCat.mint();
        belovedCat.mint();
        belovedCat.changeBelovedCat(1);
        vm.stopBroadcast();
    }

    function checkOwner() public {
        vm.startBroadcast(anvil_user);
        console2.log("ownerOf(0)", belovedCat.ownerOf(0));
        console2.log("ownerOf(4)", belovedCat.ownerOf(1));
        vm.stopBroadcast();
    }

    function changeBelovedCat() public {
        vm.startBroadcast(anvil_user);
        belovedCat.changeBelovedCat(0);
        vm.stopBroadcast();
    }
}
