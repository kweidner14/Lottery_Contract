// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Lottery {
    address public manager;
    address payable[] public players;
    address public lastWinner;
    
    constructor() {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value == .01 ether);
        players.push(payable(msg.sender));
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        lastWinner = players[index];
        players = new address payable[](0);
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function getWinner() public view returns(address) {
        return lastWinner;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

}