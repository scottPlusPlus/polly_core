package polly_core.model;

import polly_core.model.Vote.OptionRank;
import tink.core.Error;
import tink.CoreApi.Outcome;
import hawk.util.ErrorX;

class VoteX {
	public static function delta(vOld:Vote, vNew:Vote):Outcome<Vote, Error> {
		if (vOld.poll != vNew.poll) {
			var err = ErrorX.domainErr('cannot delta votes from different polls (${vOld.poll} != ${vNew.poll})');
			return Failure(err);
		}

		if (vOld.voter != vNew.voter) {
			var err = ErrorX.domainErr('cannot delta votes from different voters (${vOld.poll} != ${vNew.poll})');
			return Failure(err);
		}

		var newRanks = new Array<OptionRank>();
		for (i in 0...vOld.data.length) {
			var oldOpt = vOld.data[i];
			var opt = OptionRank.copy(oldOpt, {rank: vNew.data[i].rank - oldOpt.rank});
			newRanks.push(opt);
		}

		var res = Vote.copy(vOld, {data: newRanks});
		return Success(res);
	}
}
