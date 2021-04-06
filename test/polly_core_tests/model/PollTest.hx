package polly_core_tests.model;

import polly_core.model.PollState;
import zenlog.Log;
import haxe.Timer;
import utest.Assert;
import polly_core.model.Poll;

class PollTest extends utest.Test {
	function testCopy() {
		// Log.info('start testCopy');
		var now = Timer.stamp();
		var p1 = Poll.testExample();
		var p2 = Poll.copy(p1);
		var dur = Timer.stamp() - now;
		// Log.info("copy poll took " + dur);
		Assert.same(p1, p2);
	}

	function testJson() {
		var poll = Poll.testExample();
		var json = poll.toJson();
		Assert.isTrue(json.length > 2);

		var poll2 = Poll.fromJson(json);
		Assert.notNull(poll2);
		Assert.same(poll, poll2);
	}

	function testValidator() {
		var passingPoll = Poll.testExample();
		var validator = Poll.validator();

		var errs = validator.errors(passingPoll);
		Assert.same([], errs);

		var p = Poll.copy(passingPoll, {name: "x"});
		errs = validator.errors(p);
		Assert.isTrue(errs.length > 0);

		// closing must be after opens, for a non-Draft poll
		p = Poll.copy(passingPoll, {state: PollState.Live, closes: p.opens});
		errs = validator.errors(p);
		Assert.isTrue(errs.length > 0);
	}
}
