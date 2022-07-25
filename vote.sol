// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
// There are many proposals, each one has: name, votesCount
// There are voters, each one has: vote, hasVoted,
// Moderator: add voters, open vote, add proposal

contract DeVote {

    address public moderator;
    bool    public openedForVotes;
    bool    public hasEnded;
    struct Voter {
        uint vote;
        bool hasVoted;
    }

    struct Proposal {
        string name;
        uint    votesCount;
    }

    Proposal[] public proposals;
    mapping(address => Voter) public voters;

    modifier onlyModerator {
        require(moderator == msg.sender, "Only Moderator can perform this action!");
        _;
    }

    modifier onlyWhenOpenedForVote {
        require(openedForVotes,"The vote isn't opened yet!");
        _;
    }

    modifier onlyWhenFinished {
        require(hasEnded, "You can't perform this action now!");
        _;
    }

    constructor() {
        moderator = msg.sender;
        openedForVotes = false;
        hasEnded = false;
    }

    

    function openVote() external onlyModerator {
        openedForVotes = true;
    }

    function addProposals(string[] memory _proposals) external onlyModerator {
        for(uint i=0; i<_proposals.length; i++) {
            proposals.push(Proposal(_proposals[i], 0));
        }
    }


    function vote(uint _proposal) external onlyWhenOpenedForVote {
        require(!voters[msg.sender].hasVoted, "You already voted!");
        voters[msg.sender].vote = _proposal;
        voters[msg.sender].hasVoted = true;
        proposals[_proposal].votesCount +=1;
    }

    function endVote() external onlyModerator {
        openedForVotes = false;
        hasEnded = true;
        winningProposal();
    }

    function winningProposal() private onlyModerator onlyWhenFinished view returns(Proposal memory winner_) {
        uint maxNumOfVotes = 0;
        for(uint i=0; i< proposals.length; i++) {
            if(proposals[i].votesCount > maxNumOfVotes) {
                winner_ = proposals[i];
                maxNumOfVotes = proposals[i].votesCount;
            }
        }
        return winner_;
    }

}