package polly_core.model;

import zenlog.Log;

class StarVotingTally {
	public function new(poll:Poll) {
		for (_ in 0...poll.options.length) {
			scores.push(0);
		}
		var runoffLength = factorial(poll.options.length - 1) * 2;
		for (_ in 0...runoffLength) {
			runoffs.push(0);
		}
		//Log.debug('done creating:');
		//Log.debug(this);
	}

	public var scores:Array<Int> = [];
	public var runoffs:Array<Int> = [];

	public function add(other:StarVotingTally):StarVotingTally {
		for (i in 0...other.scores.length) {
			scores[i] += other.scores[i];
		}
		for (i in 0...other.runoffs.length) {
			runoffs[i] += other.runoffs[i];
		}
		return this;
	}

	public function addVote(vote:Vote, mult:UInt = 1):StarVotingTally {
		var voteScores = new Array<Int>();
		for (itm in vote.data) {
			scores[itm.optionID] = scores[itm.optionID] + mult * itm.value;
			voteScores.push(itm.value);
		}

		for (i in 0...voteScores.length) {
			for (j in i + 1...voteScores.length) {
				if (voteScores[i] > voteScores[j]) {
					//Log.debug('add runoff:  ${i}, ${j}, ${mult},0');
					addRunoff(i, j, mult, 0);
				} else if (voteScores[j] > voteScores[i]) {
					//Log.debug('add runoff:  ${i}, ${j}, 0, ${mult}');
					addRunoff(i, j, 0, mult);
				}
			}
		}
		//Log.debug('done adding vote:');
		//Log.debug(this);
		return this;
	}

	public function addVotes(votes:Array<Vote>):StarVotingTally {
		for (v in votes) {
			addVote(v);
		}
		return this;
	}

	public function winner():UInt {
		//Log.debug("get winner");
		var res = new StarVotingResults();
		res.scores = scores.copy();

		var first = {key: 0, value: 0};
		var second = {key: 0, value: 0};
		for (item in res.scores.keyValueIterator()) {
			if (item.value > second.value) {
				second.key = item.key;
				second.value = item.value;
			}
			if (item.value > first.value) {
				second.key = first.key;
				second.value = first.value;
				first.key = item.key;
				first.value = item.value;
			}
			//Log.debug('first:  ${first},  second: ${second}');
		}

		if (first.key > second.key) {
			var tmp = first;
			first = second;
			second = tmp;
		}
		//Log.debug('first:  ${first}  vs second: ${second}');

		var pair = getRunoff(first.key, second.key);
		//Log.debug('pair:  ${pair}');
		if (pair.optA > pair.optB) {
			return first.key;
		} else {
			return second.key;
		}
	}

	private function setRunoff(optA:UInt, optB:UInt, valA:Int, valB:Int) {
		if (optA > optB) {
			var temp = optA;
			optA = optB;
			optB = temp;
			var tempV = valA;
			valA = valB;
			valB = tempV;
		}

		var pairIndex = pairIndex(optA, optB);
		runoffs[pairIndex] = valA;
		runoffs[pairIndex + 1] = valB;
	}

	private function pairIndex(optA:UInt, optB:UInt) {
		var startingIndex = 0;
		var i = optA;
		while (i > 0) {
			startingIndex += scores.length - i;
			i--;
		}
		startingIndex = startingIndex * 2;
		var res = startingIndex + ((optB - optA - 1) * 2);
		//Log.debug('pairIndex index ${optA}, ${optB} = ${res}');
		return res;
	}

	private function addRunoff(optA:UInt, optB:UInt, valA:Int, valB:Int) {
		if (optA > optB) {
			var temp = optA;
			optA = optB;
			optB = temp;
			var tempV = valA;
			valA = valB;
			valB = tempV;
		}

		var pairIndex = pairIndex(optA, optB);
		runoffs[pairIndex] = runoffs[pairIndex] + valA;
		runoffs[pairIndex + 1] = runoffs[pairIndex + 1] + valB;
	}

	private function getRunoff(optA:UInt, optB:UInt):Runoff {
		var pairIndex = pairIndex(optA, optB);
		return {
			optA: runoffs[pairIndex],
			optB: runoffs[pairIndex + 1]
		};
	}

	private static function factorial(val:UInt):UInt {
		var res = 0;
		while (val > 0) {
			res += val;
			val--;
		}
		return res;
	}
}

typedef Runoff = {
	optA:Int,
	optB:Int
}
