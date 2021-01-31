package polly_core_tests.model;

import utest.Assert;
import polly_core.model.Poll;
import polly_core.model.StarVotingTally;

using polly_core.model.PollX;

class StarVotingTallyTest extends utest.Test {
    
    function testVotes1() {
        var poll = Poll.testExample();
        var vt1 =  poll.createVote([0,1,2]).sure();

        var tally = new StarVotingTally(poll);
        tally.addVote(vt1);

        Assert.same([0,1,2], tally.scores);
        Assert.same(2, tally.winner());
    }

    function testVotes2() {
        var poll = Poll.testExample();
        var vt1 =  poll.createVote([0,1,2]).sure();
        var vt2 =  poll.createVote([2,1,0]).sure();
        var vt3 =  poll.createVote([0,1,0]).sure();

        var tally = new StarVotingTally(poll);
        tally.addVote(vt1);
        tally.addVote(vt2);
        tally.addVote(vt3);
        Assert.same([2,3,2], tally.scores);
        Assert.same(1, tally.winner());
    }

    function testVotesComplex(){
        var poll = Poll.testExample(5);

        var vt1 =  poll.createVote([0,1,2,3,4]).sure();
        var vt2 =  poll.createVote([4,3,2,1,0]).sure();
        var vt3 =  poll.createVote([0,1,2,0,0]).sure();

        var tally = new StarVotingTally(poll);
        tally.addVote(vt1, 10);
        tally.addVote(vt2, 10);
        tally.addVote(vt3, 5);
        Assert.same([40,45,50,40,40], tally.scores);
        Assert.same(2, tally.winner());
    }

    function testAddingTallies(){
        var poll = Poll.testExample();
        var vt1 =  poll.createVote([0,1,2]).sure();
        var vt2 =  poll.createVote([2,1,0]).sure();
        var vt3 =  poll.createVote([0,1,0]).sure();

        var tally1 = new StarVotingTally(poll).addVote(vt1);
        var tally2 = new StarVotingTally(poll).addVote(vt2);
        var tally3 = new StarVotingTally(poll).addVote(vt3);

        tally1.add(tally2).add(tally3);

        Assert.same([2,3,2], tally1.scores);
        Assert.same(1, tally1.winner());
    }

    function testNoPrefVote() {
        var poll = Poll.testExample(5);
        var vt1 =  poll.createVote([0,1,2,4,4]).sure();
        var vt2 =  poll.createVote([0,1,2,4,3]).sure();

        var tally = new StarVotingTally(poll).addVote(vt1).addVote(vt2);

        Assert.same([0,2,4,8,7], tally.scores);
        Assert.same(3, tally.winner());
    }

    function testJson(){
        var poll = Poll.testExample(5);
        var vt1 =  poll.createVote([0,1,2,4,3]).sure();
        var tally = new StarVotingTally(poll).addVote(vt1, 10);
        var str = StarVotingTally.toJson(tally);
        
        var tallyBack = StarVotingTally.fromJson(str);
        Assert.same([0,10,20,40,30], tallyBack.scores);
        Assert.same(3, tallyBack.winner());
    }
}