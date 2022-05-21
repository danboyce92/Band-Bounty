// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

contract Bounty {

    uint state;
    address public manager;
    mapping(address => uint256) public contributors;
    mapping(address => bool) public vipContributors;
    uint public contributorsCount;
    uint minimumContribution = 100;
    uint vipContribution = 1000;

    constructor() {
        manager = msg.sender;
        state = 1;
    }

     modifier onlyOwner() {
        require(msg.sender == manager);
        _;
    }

    modifier redOnly() {
        require(state == 0, "Must be in RED state");
        _;
    }

    modifier greenOnly() {
        require(state == 2, "Must be in GREEN state");
        _;
    }

    modifier notRed() {
        require(state != 0, "Must not be in RED state");
        _;
    }


    function setState(uint _state) public onlyOwner {
        state = _state;        
        
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        if(contributors[msg.sender] == 0) {
        contributorsCount++;
        }
        contributors[msg.sender] = 1;

        if(msg.value >= vipContribution) {
            vipContributors[msg.sender] = true;
        }

    }


    function refund() public view redOnly returns(address) {
        return msg.sender;
    }



}
