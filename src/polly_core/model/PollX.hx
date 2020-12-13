package polly_core.model;

import tink.core.Error;
import tink.core.Outcome;
import polly_core.model.Poll;
import polly_core.model.Vote;
import hawk.core.UUID;

class PollX {

    public static function createVote(poll:Poll, voter:UUID, ranks:Array<UInt>): Outcome<Vote,Error> {
        if (ranks.length != poll.options.length){
            return Failure(new Error(ErrorCode.Forbidden, 'You must vote on every option'));
        }

        var optRanks = new Array<OptionRank>();
        for (i in 0...poll.options.length){
            var r = new Vote.OptionRank({
                optionID: poll.options[i].id,
                rank:ranks[i]
            });
            optRanks.push(r);
        }
        var v = new Vote({
            poll:poll.id,
            voter: voter,
            data:optRanks
        });
        return Success(v);
    }

    public static function addVotes(poll:Poll, votes:Array<Vote>):Outcome<Poll,Error> {
        for (v in votes){
            if (v.poll != poll.id){
                var err = new Error(ErrorCode.Forbidden, 'cannot add vote for ${v.poll} to poll ${poll.id}');
                return Failure(err);
            }
        }

        var optionTotals = new Map<UInt,Array<UInt>>();
        var ensureOption = function(id:UInt):Array<UInt> {
            var opt = optionTotals.get(id);
            if (opt == null){
                opt = new Array<UInt>();
                for (i in 0...poll.options.length){
                    opt.push(0);
                }
                optionTotals.set(id, opt);
            }
            return opt;
        }
        for (v in votes){
            for (data in v.data){
                var opt = ensureOption(data.optionID);
                opt[data.rank] = opt[data.rank] +1;
            }
        }
        var newOpts = new Array<Option>();
        for (opt in poll.options){
            var newVotes = optionTotals.get(opt.id);
            var newOpt = Option.copy(opt, {votes:newVotes});
            newOpts.push(newOpt);
        }

        var res = Poll.copy(poll, {options: newOpts});
        return Success(res);
    }
}