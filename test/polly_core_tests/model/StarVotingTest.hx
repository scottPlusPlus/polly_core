package polly_core_tests.model;

import utest.Assert;
import polly_core.model.StarVoting;
import polly_core.model.VoteType;
import polly_core.model.Poll;

using polly_core.model.PollX;

class StarVotingTest  extends utest.Test {
    
    function testCase1() {

        var poll = Poll.testExample();
        var vt1 = createType(poll, [0,1,2], 10);
        var vt2 = createType(poll, [0,2,1], 20);
        var res = StarVoting.tally(poll, [vt1, vt2]);
        Assert.equals(1, res.winnerIndex);
    }

    function testCase2() {
        var poll = Poll.testExample(4);
        var vt1 = createType(poll, [0,1,2,3], 10);
        var vt2 = createType(poll, [3,2,1,0], 10);
        var vt3 = createType(poll, [2,3,1,0], 10);
        var res = StarVoting.tally(poll, [vt1, vt2, vt3]);
        Assert.equals(1, res.winnerIndex);
    }

    function testCase3() {
        var poll = Poll.testExample(4);
        var vt1 = createType(poll, [0,1,2,3], 10);
        var vt2 = createType(poll, [3,2,1,0], 10);
        var vt3 = createType(poll, [2,3,1,0], 10);
        var res = StarVoting.tally(poll, [vt1, vt2, vt3]);
        Assert.equals(1, res.winnerIndex);
    } 


    function createType(poll:Poll, votes:Array<UInt>, count:UInt): VoteType {
        var vote = poll.createVote(votes).sure();
        var vt = VoteType.fromVote(vote);
        return VoteType.copy(vt, {count:count});
    }

}