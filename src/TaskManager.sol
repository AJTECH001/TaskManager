// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TaskManager {
    struct Task {
        uint256 id;
        string description;
        bool completed;
        address owner;
        uint256 createdAt;
    }

    mapping(uint256 => Task) public tasks;
    mapping(address => uint256[]) public userTasks;
    uint256 public taskCounter;

    event TaskCreated(uint256 indexed taskId, address indexed owner, string description);
    event TaskCompleted(uint256 indexed taskId, address indexed owner);
    event TaskDeleted(uint256 indexed taskId, address indexed owner);

    modifier onlyTaskOwner(uint256 _taskId) {
        require(tasks[_taskId].owner == msg.sender, "Not task owner");
        _;
    }

    modifier taskExists(uint256 _taskId) {
        require(tasks[_taskId].owner != address(0), "Task does not exist");
        _;
    }

    function createTask(string memory _description) external {
        require(bytes(_description).length > 0, "Description cannot be empty");

        taskCounter++;

        tasks[taskCounter] = Task({
            id: taskCounter,
            description: _description,
            completed: false,
            owner: msg.sender,
            createdAt: block.timestamp
        });

        userTasks[msg.sender].push(taskCounter);

        emit TaskCreated(taskCounter, msg.sender, _description);
    }

    function completeTask(uint256 _taskId) external taskExists(_taskId) onlyTaskOwner(_taskId) {
        require(!tasks[_taskId].completed, "Task already completed");

        tasks[_taskId].completed = true;

        emit TaskCompleted(_taskId, msg.sender);
    }

    function deleteTask(uint256 _taskId) external taskExists(_taskId) onlyTaskOwner(_taskId) {
        // Remove from user's task array
        uint256[] storage userTaskArray = userTasks[msg.sender];
        for (uint256 i = 0; i < userTaskArray.length; i++) {
            if (userTaskArray[i] == _taskId) {
                userTaskArray[i] = userTaskArray[userTaskArray.length - 1];
                userTaskArray.pop();
                break;
            }
        }

        delete tasks[_taskId];

        emit TaskDeleted(_taskId, msg.sender);
    }

    function getUserTasks(address _user) external view returns (uint256[] memory) {
        return userTasks[_user];
    }

    function getTask(uint256 _taskId) external view returns (Task memory) {
        return tasks[_taskId];
    }

    function getUserTaskDetails(address _user) external view returns (Task[] memory) {
        uint256[] memory taskIds = userTasks[_user];
        Task[] memory userTaskDetails = new Task[](taskIds.length);

        for (uint256 i = 0; i < taskIds.length; i++) {
            userTaskDetails[i] = tasks[taskIds[i]];
        }

        return userTaskDetails;
    }
}
