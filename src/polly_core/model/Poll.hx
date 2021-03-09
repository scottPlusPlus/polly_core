package polly_core.model;

import hawk.datatypes.Timestamp;
import polly_core.model.PollID;
import hawk.datatypes.UUID;

//we need to track which users have voted on a poll
//but only to prevent those same users from voting again
//will be better to store all voted on polls...

class Poll implements DataClass {
    public final id:PollID;
    public final owner:UUID;
    public final description:String;
    public final state:PollState;
    public final options:Array<Option>;
    public final opens:Timestamp;
    public final closes:Timestamp;

    // public static function initVotes(p:Poll):Poll {
    //     var emptyArr = new Array<UInt>();
    //     for (_ in 0...p.options.length){
    //         emptyArr.push(0);
    //     }
    //     var newOptions = new Array<Option>();
    //     for (opt in p.options){
    //         var newOpt = Option.copy(opt, {votes: emptyArr.copy()});
    //         newOptions.push(newOpt);
    //     }
    //     p = Poll.copy(p, {options:newOptions});
    //     return p;
    // }

    public static function fromJson(str:String): Poll {
        var parser = new json2object.JsonParser<Poll>();
        return parser.fromJson(str);
    }

    public function toJson():String {
        var writer = new json2object.JsonWriter<Poll>();
        return writer.write(this);
    }

    public static function testExample(options:UInt = 3):Poll {
        var opts = new Array<Option>();
        for (i in 0...options){
            var opt = new Option({
                id:i,
                info: 'Option ${i}'
            });
            opts.push(opt);
        }
        
        var closes = Timestamp.now() + Timestamp.HOUR * 24;
        var p = new Poll({
            id: PollID.gen(),
            owner: UUID.gen(),
            description: "test poll",
            state: PollState.Draft,
            options: opts,
            opens: Timestamp.fromUInt(0),
            closes:closes
        });
        return p;
    }

}

class Option implements DataClass {
    public final id:UInt;
    public final info:String;
}