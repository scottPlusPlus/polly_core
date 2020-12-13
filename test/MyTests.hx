package test;

import hawk.testutils.TestLogger;
import zenlog.Log;
import haxe.Json;
import utest.ui.Report;
import utest.Assert;
import utest.Async;
import utest.Runner;

class MyTests {
	public static function main() {
		TestLogger.init();
		TestLogger.filter.indentStackStart = 18;

		var runner = new Runner();
		runner.addCases(test.polly_core);

		Report.create(runner);

		ageWarning();

		runner.run();
	}

	static function ageWarning():Void {
		var buildTime = CompileTime.buildDate();
		var now = Date.now();
		var dur = now.getTime() - buildTime.getTime();
		var seconds = Math.floor(dur / 1000);

		var minutes = seconds / 60;
		if (minutes > 1) {
			Log.warn('WARN! \n\nBuild is  ${minutes} minutes old\n\n WARN');
		}
	}
}
