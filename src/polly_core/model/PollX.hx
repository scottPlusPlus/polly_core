package polly_core.model;

import tink.core.Error;
import tink.core.Outcome;
import polly_core.model.Poll;
import polly_core.model.Vote;
import hawk.core.UUID;

class PollX {

    public static function createVote(poll:Poll, values:Array<UInt>): Outcome<Vote,Error> {
        if (values.length != poll.options.length){
            return Failure(new Error(ErrorCode.Forbidden, 'You must vote on every option'));
        }

        var optValues = new Array<OptionValue>();
        for (i in 0...poll.options.length){
            var r = new Vote.OptionValue({
                optionID: poll.options[i].id,
                value:values[i]
            });
            optValues.push(r);
        }
        var v = new Vote({
            poll:poll.id,
            data:optValues
        });
        return Success(v);
    }
}