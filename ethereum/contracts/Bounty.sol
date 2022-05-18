// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.17;

import './LinkOracle.sol';

contract BountyFactory is LinkOracle {
    address[] public deployedBounties;

    function createBounty(uint minimum) public {
        address newBounty = new Bounty(minimum, msg.sender);
        deployedBounties.push(newBounty);

    }

    function getDeployedBounties() public view returns(address[]) {
        return deployedBounties;
    }

}

contract Bounty {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }


    Request[] public requests; 
    address public manager;
    uint public minimumContribution;
    mapping(address => uint256) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Bounty(uint minimum, address creator, string band, string city) public {
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        if(approvers[msg.sender] == 0) {
        approversCount++;
        }
        approvers[msg.sender] = 1;

    }

    function createRequest(string description, uint value, address recipient) 
        public  restricted {
            Request memory newRequest = Request({
                description: description,
                value: value,
                recipient: recipient,
                complete: false,
                approvalCount:0
            });
            requests.push(newRequest);
        }

        function approveRequest(uint index) public {
            Request storage request = requests[index];
            require(approvers[msg.sender]);
            require(!request.approvals[msg.sender]);

            request.approvals[msg.sender] = true;
            request.approvalCount++;
        }

        function finalizeRequest(uint index) public restricted {
            Request storage request = requests[index];
            require(request.approvalCount >= (approversCount / 2));
            require(!request.complete);

            request.recipient.transfer(request.value);
            request.complete = true;


        }

   function getSummary() public view returns (
       uint, uint, uint, uint, address
   ) {
       return (
           minimumContribution,
           this.balance,
           requests.length,
           approversCount,
           manager
       );
   }

   function getRequestsCount() public view returns (uint) {
       return requests.length;
   }

}
