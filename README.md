# Band-Bounty



#Changes
**function contribute()** had a weird bug that if somebody that contributed, contributed again it would still increment the approvers count. I only want this to increment per new contributor. 
I had to change the approvers mapping from address => bool to
address => uint256.
Some issue with bool, works fine now that I've set an if statement
