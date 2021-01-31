package polly_core.model;

import tink.CoreApi.Outcome;
import tink.CoreApi.Error;

class StarVoting {


    public static function validateVote(poll:Poll, vote:Vote):Outcome<Vote,Error> {
        if (vote.data.length != poll.options.length){
            return Failure(new Error('Should provide a vote for each option'));
        }

        //TODO - more validation
        return Success(vote);
    }

    public static function tally(poll:Poll, votes:Array<VoteType>): StarVotingResults {
        //TODO - ties??
        var res = new StarVotingResults();

        var optionToIndex = new Map<UInt,UInt>();

        for (i in 0...poll.options.length){
            res.scores.push(0);
            optionToIndex.set(i, poll.options[i].id);
        }

        //first find top 2...
        for (vt in votes){
            for (opt in vt.vote.data){
                var index = optionToIndex.get(opt.optionID);
                var val = res.scores[index];
                val += opt.value * vt.count;
                res.scores[index] = val;
            }
        }

        var first = {key:  0, value: 0};
        var second = {key: 0, value: 0};
        for (item in  res.scores.keyValueIterator()) {
            if(item.value > second.value){
                second.key = item.key;
                second.value = item.value;
            }
            if (item.value > first.value){
                second.key = first.key;
                second.value = first.value;
                first.key = item.key;
                first.value = item.value;
            }
        }

        var firstHighers = 0;
        var secondHighers = 0;
        for (vt in votes){
            var firstScore = 0;
            var secondScore = 0;
            for (opt in vt.vote.data){
                if (opt.optionID == first.key){
                    firstScore = opt.value;
                } else if (opt.optionID == second.key){
                    secondScore = opt.value;
                }
            }
            if (firstScore > secondScore){
                firstHighers += vt.count;
            } else {
                secondHighers += vt.count;
            }            
        }

        if (firstHighers > secondHighers){
            res.winnerIndex = first.key;
        } else {
            res.winnerIndex = second.key;
        }
        return res;
    }


}