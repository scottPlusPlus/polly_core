package polly_core_tests.model;


import zenlog.Log;
import utest.Assert;
import hawk.core.UUID;
import polly_core.model.Poll;
import polly_core.model.Vote;
import polly_core.model.VoteX;

using polly_core.model.PollX;

class VoteXTest extends utest.Test {

    function testDeltas() {

        var poll = Poll.testExample();
		var voter = UUID.gen();

        //sanity test we didn't change the test data
		Assert.equals(3, poll.options.length);

        // var vote1 = poll.createVote(voter, [0, 1, 2]).sure();
        // var vote2 = poll.createVote(voter, [2, 1, 0]).sure();

        // var merged = VoteX.delta(vote1, vote2).sure();
        // Assert.equals(2, merged.data[0].rank);
        // Assert.equals(0, merged.data[1].rank);
        // Assert.equals(-2, merged.data[2].rank);
        // Log.debug(vote1.toJson());
        // Log.debug(vote2.toJson());
        // Log.debug(merged.toJson());

        // var pollWithMerged = poll.addVotes([vote1, merged]).sure();
        // var pollWith2 = poll.addVotes([vote2]).sure();
        // Log.debug(pollWithMerged.toJson());
        // Log.debug(pollWith2.toJson());
        // Assert.same(pollWith2, pollWithMerged);
	}

}
