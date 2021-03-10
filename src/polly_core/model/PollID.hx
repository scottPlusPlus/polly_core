package polly_core.model;

import hawk.general_tools.adapters.Adapter;
import hawk.datatypes.UUID;

abstract PollID(UUID) {
	private function new(u:UUID) {
		this = u;
	}

	@:from
	static public inline function fromUUID(u:UUID) {
		return new PollID(u);
	}

	@:to
	public inline function toUUID() {
		return this;
	}

	@:from
	static public inline function fromString(s:String) {
		return PollID.fromUUID(UUID.fromString(s));
	}

	@:to
	public inline function toString() {
		return this.toString();
	}

	public static inline function gen():PollID {
		var u = UUID.gen();
		return new PollID(u);
	}

	public static function stringAdapter():Adapter<PollID, String> {
		return new Adapter<PollID, String>(Std.string, PollID.fromString);
	}
}
