
package pixeldroid.bdd
{
	import pixeldroid.bdd.Matcher;
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.models.Expectation;
	import pixeldroid.bdd.models.MatchResult;
	import pixeldroid.random.Randomizer;


	public class Thing
	{
		private var name:String = '<thing>';
		private var expectations:Vector.<Expectation> = [];
		private var currentExpectation:Expectation;


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
			Randomizer.shuffle(expectations);

			var e:Expectation;
			var i:Number;
			var n:Number = expectations.length;

			reporter.begin(name, n);

			for (i = 0; i < n; i++)
			{
				currentExpectation = expectations[i];

				// run the validation closure, which has captured this instance in its scope
				// it will call in to expects(), which will pass flow on to Matcher
				// which will call addResult()
				currentExpectation.test();

				reporter.report(currentExpectation, i, n);
			}

			currentExpectation = null;

			reporter.end();
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