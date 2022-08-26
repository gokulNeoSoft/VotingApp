const ElectionContract = artifacts.require('election');
const chai = require('chai');
const truffleAssert = require('truffle-assertions');
contract("election",(accounts)=>{
    var [a, b,c] = accounts;
    console.log("account ",accounts);
    var contractInstance;
    beforeEach(async () => {
        contractInstance = await ElectionContract.new();
        await contractInstance.addContestent(a,"cont0","testProp");
    });
    it("Should return already a contestent error",async function(){
        await truffleAssert.reverts(contractInstance.addContestent(a,"cont1","testProp"),"Already a contestent");
    })

    it("Should return already a voter error",async function(){
        await truffleAssert.reverts(contractInstance.addVoter(a,"voter1"),"Already a voter");
    })

    it("checking get proposal function", async function(){
        var res = await contractInstance.getProposal(a);
        await expect(res).is.equal("testProp");
        await truffleAssert.reverts(contractInstance.getProposal(b),"Not a contestent");
    })
    it("Cast vote test",async function(){
        await truffleAssert.reverts(contractInstance.castVote(a));
        await truffleAssert.reverts(contractInstance.castVote(c));
    })
    it("get winner test",async function(){
        await contractInstance.startVoting();
        await contractInstance.castVote(a);
        await contractInstance.endElection();
        console.log(await contractInstance.getWinner());
    })
})