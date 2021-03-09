package polly_core_tests.model;

import utest.Assert;
import hawk.datatypes.UUID;
import polly_core.model.Poll;

using polly_core.model.PollX;

class PollXTest extends utest.Test {
	function testCreateVote() {
		var poll = Poll.testExample();
		trace('default poll example: ' + poll.toJson());

        //sanity test we didn't change the test data
		Assert.equals(3, poll.options.length);

		var createVote = poll.createVote([0, 2, 1]);
		Assert.isTrue(createVote.isSuccess());

		var vote = createVote.sure();
		Assert.equals(poll.id, vote.poll);
		Assert.equals(3, vote.data.length);
		Assert.equals(0, vote.data[0].value);
		Assert.equals(2, vote.data[1].value);
		Assert.equals(1, vote.data[2].value);
	}

}
