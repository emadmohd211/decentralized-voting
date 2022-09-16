// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SmartVoting{
    enum STATES{
        OPEN,
        CLOSED
    }
    struct VOTER{
        string partyName;
        bool voted;
        address myAddress;
    }
    struct PARTIES{
        string name;
        uint256 votes;
    }
    struct PARTIESS{
        string name;
        uint256 votes;
    }
    VOTER[] public voters;
    mapping(address => VOTER) public connection;
    PARTIES[] public parties;
    PARTIES public winner;
    STATES public currentState;
    string public ex;
    // constructor(string[] memory _parties) public {
    constructor() { 
        currentState = STATES.CLOSED;
        // ex = _parties[1];
        parties.push(PARTIES("Democrats", 0));
        parties.push(PARTIES("Republic", 0));
        parties.push(PARTIES("OTHERS", 0));
    }
    function startVoting() public {
        require(currentState == STATES.CLOSED, "The voting is already open");
        currentState = STATES.OPEN;
    }

    function vote(uint256 val) public{
        bool present = false;
        require(currentState == STATES.OPEN, "The voting hasnt been started");
        if(connection[msg.sender].voted)
            present = !present;
        require(!present, "You have already voted");
        parties[val].votes++;
        voters.push(VOTER(parties[val].name, true, msg.sender));
        uint256 size = voters.length;
        connection[msg.sender] = voters[size-1];
    }

    function endVoting() public returns(string memory){
        require(currentState == STATES.OPEN, "The voting is already closed");
        currentState = STATES.CLOSED;
        uint256 index;
        uint256 max = 0;
        for(uint256 i = 0;i<parties.length;i++)
        {
            if(max < parties[i].votes) 
            { 
                index = i;
                max = parties[i].votes;
            }
        }
        winner = parties[index];
        return parties[index].name;
    }
}