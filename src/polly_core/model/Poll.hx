package polly_core.model;

import polly_core.model.PollID;
import hawk.core.UUID;

//we need to track which users have voted on a poll
//but only to prevent those same users from voting again
//will be better to store all voted on polls...

class Poll implements DataClass {
    public final id:PollID;
    public final owner:UUID;
    public final description:String;
    public final state:PollState;
    public final options:Array<Option>;

    public static function initVotes(p:Poll):Poll {
        var emptyArr = new Array<UInt>();
        for (_ in 0...p.options.length){
            emptyArr.push(0);
        }
        var newOptions = new Array<Option>();
        for (opt in p.options){
            var newOpt = Option.copy(opt, {votes: emptyArr.copy()});
            newOptions.push(newOpt);
        }
        p = Poll.copy(p, {options:newOptions});
        return p;
    }

    public static function fromJson(str:String): Poll {
        var parser = new json2object.JsonParser<Poll>();
        return parser.fromJson(str);
    }

    public function toJson():String {
        var writer = new json2object.JsonWriter<Poll>();
        return writer.write(this);
    }

    public static function testExample():Poll {
        var p = new Poll({
            id: PollID.gen(),
            owner: UUID.gen(),
            description: "test poll",
            state: PollState.Draft,
            options: [
                new Option({
                    id:0,
                    info:"Option 1",
                    votes:[]
                }),
                new Option({
                    id:1,
                    info:"Option 2",
                    votes:[]
                }),
                new Option({
                    id:2,
                    info:"Option 3",
                    votes:[]
                })
            ]
        });
        return p;
    }

}

class Option implements DataClass {
    public final id:UInt;
    public final info:String;

    /*
        votes at a given rank. ex: [1, 2, 3] means the option was given 3 votes at rank index2...
    */
    public final votes:Array<UInt>;
}