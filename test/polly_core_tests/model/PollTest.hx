package polly_core_tests.model;

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
}