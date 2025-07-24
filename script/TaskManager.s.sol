// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TaskManager} from "../src/TaskManager.sol";

contract TaskManagerScript is Script {
    function run() external {
        vm.startBroadcast();

        TaskManager taskManager = new TaskManager();

        console.log("TaskManager deployed to:", address(taskManager));

        vm.stopBroadcast();
    }
}
    