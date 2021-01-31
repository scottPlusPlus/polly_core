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
}