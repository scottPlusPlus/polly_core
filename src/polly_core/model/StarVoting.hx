package polly_core.model;

import hawk.datatypes.Timestamp;
import tink.CoreApi.Outcome;
import tink.CoreApi.Error;

class StarVoting {


    public static function validateVote(poll:Poll, vote:Vote):Outcome<Vote,Error> {
        if (vote.data.length != poll.options.length){
            return Failure(new Error('Should provide a vote for each option'));
        }

        var now = Timestamp.now();
        if (poll.opens > now){
            return Failure(new Error('poll is not open yet'));
        }

        if (poll.closes < now){
            return Failure(new Error('Poll is already closed'));
        }

        //TODO - more validation
        return Success(vote);
    }
}