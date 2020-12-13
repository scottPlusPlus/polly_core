package polly_core.model;

import hawk.core.UUID;

class Vote implements DataClass  {
    public final poll:PollID;
    public final voter:UUID;
    public final data:Array<OptionRank>;

    public static function testExample():Vote {
        var rank0 = new OptionRank({
            optionID: 0,
            rank:1
        });
        var rank1 = new OptionRank({
            optionID: 1,
            rank:2
        });
        var rank2 = new OptionRank({
            optionID: 2,
            rank:0
        });
        return new Vote({
            poll:PollID.gen(),
            voter:UUID.gen(),
            data:[rank0, rank1, rank2]
        });
    }

    public static function fromJson(str:String): Vote {
        var parser = new json2object.JsonParser<Vote>();
        return parser.fromJson(str);
    }

    public function toJson():String {
        var writer = new json2object.JsonWriter<Vote>();
        return writer.write(this);
    }
}

class OptionRank implements DataClass {
    public final optionID: UInt;
    public final rank:Int;
}
