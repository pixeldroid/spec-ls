
package pixeldroid.bdd
{
	import pixeldroid.bdd.Matcher;
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.models.Expectation;
	import pixeldroid.bdd.models.MatchResult;
	import pixeldroid.random.Randomizer;

	import system.platform.Platform;


	public class Thing
	{
		private var name:String = '<thing>';
		private var expectations:Vector.<Expectation> = [];
		private var currentExpectation:Expectation;
		private var startTimeMs:Number;


		public function Thing(name:String)
		{
			this.name = name;
		}


		public function should(declaration:String, validation:Function):void
		{
			expectations.push(new Expectation(declaration, validation));
		}

		public function execute(reporter:Reporter):void
		{
			startTimeMs = Platform.getTime();
			Randomizer.shuffle(expectations);

			var e:Expectation;
			var i:Number;
			var n:Number = expectations.length;
			var ms:Number;

			reporter.begin(name, n);

			for (i = 0; i < n; i++)
			{
				ms = Platform.getTime();

				currentExpectation = expectations[i];

				// run the validation closure, which has captured this instance in its scope
				// it will call in to expects(), which will pass flow on to Matcher
				// which will call addResult()
				currentExpectation.test();

				reporter.report(currentExpectation, (Platform.getTime() - ms) * .001, i, n);
			}

			currentExpectation = null;

			reporter.end(name, (Platform.getTime() - startTimeMs) * .001);
		}


		/// used by closures
		public function expects(value:Object):Matcher
		{
			var matcher:Matcher = new Matcher(this, value);
			return matcher;
		}

		public function addResult(result:MatchResult):void
		{
			currentExpectation.addResult(result);
		}

	}
}