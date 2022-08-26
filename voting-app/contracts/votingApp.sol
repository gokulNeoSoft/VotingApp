pragma solidity >=0.7.0 <0.9.0;
import "./Owner.sol";

contract election is Owner {
    struct people{
        bool isContestent;
        string name;
        bool isVoted;
        string proposal;
        address addr;
    }
    bool isVotingStarted = false;
    uint votingStartTime;
    uint votingTime = 30 seconds;
    bool isVotingEnded = false;
    mapping(address => people) private peoples ;
    mapping(address => uint256) private addrToVoteCount;
    people[] public contestents;

    event votingStarted();  

    function addContestent (address _addr , string memory _name ,string memory _proposal ) public isOwner{
        require(peoples[_addr].isContestent==false,"Already a contestent");
        require(isVotingStarted==false,"Voting already started");
        peoples[_addr]=people(true, _name,false,_proposal,_addr);
        contestents.push(people(true, _name,false,_proposal,_addr));
        addrToVoteCount[_addr]=0;
    }

    function addVoter (address _addr , string memory _name ) public isOwner{
        require(peoples[_addr].isContestent==false,"Already a voter");
        require(isVotingStarted==false,"Voting already started");
        peoples[_addr]=people(false, _name,false,"nil",_addr);

    }

    function getProposal(address _addr) public view returns(string memory){
        require(peoples[_addr].isContestent==true,"Not a contestent");
        return peoples[_addr].proposal;
    }

    function getContestents() public view returns(people[] memory){
        return contestents;
    }

    function startVoting() public isOwner{
        isVotingStarted = true ;
        votingStartTime = block.timestamp;
        emit votingStarted();           
    }

    function castVote(address _addr) public  {
        require(peoples[_addr].isContestent==true && isVotingStarted==true);
        require(votingStartTime + votingTime > block.timestamp);
        require(peoples[msg.sender].isVoted==false , "Already Voted");
        peoples[msg.sender].isVoted= true;
        addrToVoteCount[_addr]++;
    }


    function endElection() public isOwner{
        isVotingEnded =true;
    }

    function getWinner() public view returns(people memory){
        require(votingStartTime + votingTime <= block.timestamp || isVotingEnded == true);
        people memory winner;
        uint highestVote = 0;
        for(uint i=0;i<contestents.length;i++){
            if(addrToVoteCount[contestents[i].addr]>highestVote){
                highestVote = addrToVoteCount[contestents[i].addr];
                winner = contestents[i];
            }
        }
        return winner;
    }
}

