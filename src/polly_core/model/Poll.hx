package polly_core.model;

import hawk.datatypes.validator.ValidationOutcome;
import hawk.datatypes.validator.Validator;
import tink.core.Error;
import tink.CoreApi.Outcome;
import hawk.datatypes.validator.StringValidator;
import hawk.general_tools.adapters.Adapter;
import hawk.datatypes.Timestamp;
import polly_core.model.PollID;
import hawk.datatypes.UUID;

using hawk.util.OutcomeX;

//we need to track which users have voted on a poll
//but only to prevent those same users from voting again
//will be better to store all voted on polls...

class Poll implements DataClass {
    public final id:PollID;
    public final owner:UUID;
    public final name:String;
    public final description:String;
    public final state:PollState;
    public final options:Array<Option>;
    public final opens:Timestamp;
    public final closes:Timestamp;


    public static function baseDraft():Poll {
        var now = Timestamp.now();
        return new Poll({
            id: UUID.gen(),
            owner: "",
            name: "",
            description: "",
            state: PollState.Draft,
            options: [],
            opens: now,
            closes :Timestamp.DAY * 3 + now
        });
    }

    public static function fromJson(str:String): Poll {
        var parser = new json2object.JsonParser<Poll>();
        return parser.fromJson(str);
    }

    public function toJson():String {
        var writer = new json2object.JsonWriter<Poll>();
        return writer.write(this);
    }

    public static function stringAdapter():Adapter<Poll,String>{
        return new Adapter(function(p:Poll):String{
            return p.toJson();
        }, fromJson);
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
            name: "TestPoll",
            description: "A test poll",
            state: PollState.Draft,
            options: opts,
            opens: Timestamp.fromUInt(0),
            closes:closes
        });
        return p;
    }


    public static function validator(): PollValidator {
        return new PollValidator();
    }

	public static function validOrErr(poll:Poll):Outcome<Poll, Error> {
		var errs = validator().errors(poll);
		if (errs.length > 0) {
			return Failure(new Error('Invalid Email: ${errs.join(', ')}'));
		}
		return Success(poll);
	}

}

class Option implements DataClass {
    public final id:UInt;
    public final info:String;
}

class PollValidator extends Validator<Poll> {

    public function new(){
        super();
        nameValidator = new StringValidator("Name").nonNull().minChar(3).maxChar(128).trim();
        descriptionValidator = new StringValidator("Description").nonNull().minChar(3).maxChar(512);
        ownerValidator = new StringValidator('Owner').nonNull().minChar(8).maxChar(32);
        opensValidator = new StringValidator('Opens').nonNull().addRule(validTimestamp);

        addSubValidator(function(p){
            return p.name;
        }, nameValidator);

        addSubValidator(function(p){
            return p.description;
        }, descriptionValidator);

        addSubValidator(function(p){
            return p.owner.toString();
        }, ownerValidator);
        
        addRule(function(p){
            if (p.state == PollState.Draft){
                return Pass;
            }
            var v = nonDraftValidator();
            var errs = v.errors(p);
            return Validator.outcomeFromArray(errs);
        });  
    }

    public final nameValidator:StringValidator;
    public final descriptionValidator: StringValidator;
    public final ownerValidator: StringValidator;
    public final opensValidator: StringValidator;

    private static function nonDraftValidator():Validator<Poll> {
        var validator = new Validator<Poll>();
        validator.addRule(function(p){
            if (p.opens.toInt() >= p.closes.toInt()){
                return Fail(['Invalid Poll Closing Time']);
            }
            return Pass;
        });
        validator.addRule(function(p){
            if (p.options.length < 2){
                return Fail(['Poll must have at least 2 options']);
            }
            return Pass;
        });
        return validator;
    }

    private static function validTimestamp(str:String):ValidationOutcome {
        var attempt = Timestamp.fromFormString(str);
        if (attempt.isSuccess()){
            return Pass;
        }
        return Fail(['Invalid date-time. Expecting something like "2020-04-08 12:34:56"']);
    }
}