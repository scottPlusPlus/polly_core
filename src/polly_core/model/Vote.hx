package polly_core.model;

import hawk.datatypes.UUID;

class Vote implements DataClass  {
    public final poll:PollID;
    public final data:Array<OptionValue>;

    public static function testExample():Vote {
        var rank0 = new OptionValue({
            optionID: 0,
            value:1
        });
        var rank1 = new OptionValue({
            optionID: 1,
            value:2
        });
        var rank2 = new OptionValue({
            optionID: 2,
            value:0
        });
        return new Vote({
            poll:PollID.gen(),
            data:[rank0, rank1, rank2]
        });
    }

    public static function fromJson(str:String): Vote {
        var parser = new json2object.JsonParser<Vote>();
        return parser.fromJson(str);
    }

    public static function toJson(v:Vote):String {
        var writer = new json2object.JsonWriter<Vote>();
        return writer.write(v);
    }

    public function hash():String {
        var j = Vote.toJson(this);
        var hash = haxe.crypto.Md5.encode(j);
        return hash;
    }
}

class OptionValue implements DataClass {
    public final optionID: UInt;
    public final value:Int;
}
