package polly_core.service;

import polly_core.model.PollID;
import polly_core.model.StarVotingTally;
import polly_core.model.Vote;
import tink.CoreApi;
import polly_core.model.Poll;
import hawk.core.UUID;

interface IPollService {

    function createPoll(actor:UUID, poll:Poll):Promise<Poll>;
    function updatePoll(actor:UUID, newPollState:Poll):Promise<Poll>;

    public function voteOnPoll(actor:UUID, vote:Vote):Promise<Poll>;
    public function getUserPolls(actor:UUID):Promise<Array<Poll>>;
    public function getUserVotes(actor:UUID):Promise<Array<Vote>>;

    public function getPollByID(id:UUID):Promise<Poll>;

    public function getPollResults(pollID:PollID):Promise<StarVotingTally>;

}