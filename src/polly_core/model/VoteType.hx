package polly_core.model;

class VoteType implements DataClass {

    public final hash:String;
    public final count:UInt;
    public final vote:Vote;

    public static function fromJson(str:String): VoteType {
        var parser = new json2object.JsonParser<VoteType>();
        return parser.fromJson(str);
    }

    public static function toJson(v:VoteType):String {
        var writer = new json2object.JsonWriter<VoteType>();
        return writer.write(v);
    }

    public static function fromVote(v:Vote):VoteType {
        return new VoteType({
            hash: v.hash(),
            count: 0,
            vote: v
        });
    }

}