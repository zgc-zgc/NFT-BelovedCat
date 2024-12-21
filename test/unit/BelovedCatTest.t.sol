// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {DeployBelovedCat} from "../../script/DeployBelovedCat.s.sol";
import {BelovedCat} from "../../src/BelovedCat.sol";

contract BelovedCatTest is Test {
    DeployBelovedCat public deployer;
    BelovedCat public belovedCat;
    address public USER = makeAddr("user");
    address public USER2 = makeAddr("user2");

    function setUp() public {
        deployer = new DeployBelovedCat();
        belovedCat = deployer.run();
    }

    function test_mint_success_whenCalled() public {
        vm.prank(USER);
        belovedCat.mint();

        assertEq(belovedCat.balanceOf(USER), 1);
        assertEq(belovedCat.ownerOf(0), USER);
        assertEq(belovedCat.getTokenCounter(), 1);
        assertTrue(belovedCat.getBelovedCat(0) == BelovedCat.CatType.BuBu);
    }

    function test_mintSpecficTokenId_Success_WhenTokenIdVaild() public {
        vm.prank(USER);
        belovedCat.mintSpecficTokenId(1);
        assertEq(belovedCat.balanceOf(USER), 1);
        assertEq(belovedCat.ownerOf(1), USER);
        assertTrue(belovedCat.getBelovedCat(1) == BelovedCat.CatType.BuBu);
    }

    function test_mintSpecficTokenId_Fail_WhenTokenIdInvalid() public {
        vm.prank(USER);
        belovedCat.mintSpecficTokenId(1);
        vm.prank(USER2);
        vm.expectRevert(BelovedCat.BelovedCat__AlreadyMinted.selector);
        belovedCat.mintSpecficTokenId(1);
    }

    function test_changeBelovedCat_Success_WhenCalledByOwner() public {
        vm.startPrank(USER);
        belovedCat.mint();
        assertTrue(belovedCat.getBelovedCat(0) == BelovedCat.CatType.BuBu);
        belovedCat.changeBelovedCat(0);
        vm.stopPrank();
        assertTrue(belovedCat.getBelovedCat(0) == BelovedCat.CatType.XiaoHei);
    }

    function test_changeBelovedCat_Fail_WhenCalledByNotOwner() public {
        vm.prank(USER);
        belovedCat.mint();
        vm.prank(USER2);
        vm.expectRevert(abi.encodeWithSelector(BelovedCat.BelovedCat__NotOwner.selector, USER2));
        belovedCat.changeBelovedCat(0);
    }

    function test_changeBelovedCat_Fail_WhenTokenIdDoesNotExist() public {
        vm.prank(USER);
        vm.expectRevert(abi.encodeWithSelector(BelovedCat.BelovedCat__TokenDoesNotExist.selector, 0));
        belovedCat.changeBelovedCat(0);
    }
}
