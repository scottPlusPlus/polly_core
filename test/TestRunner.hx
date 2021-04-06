import hawk.testutils.TestLog;
import utest.ui.Report;
import utest.Runner;

class TestRunner {
	public static function main() {
		TestLog.init();

		var runner = new Runner();
		runner.addCases(polly_core_tests);
		runner.onTestStart.add(function(x) {
			TestLog.startTest(x.fixture.method);
		});
		runner.onTestComplete.add(function(x) {
			for (assert in x.results) {
				switch (assert) {
					case Failure(msg, pos):
						TestLog.debugForTest();
						break;
					case Error(e, stack):
						TestLog.debugForTest();
						break;
					default:
				}
			}
			TestLog.finishTest();
		});


		Report.create(runner);
		TestLog.ageWarning();
		runner.run();
	}
}
