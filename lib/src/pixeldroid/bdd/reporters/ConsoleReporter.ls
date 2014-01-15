
package pixeldroid.bdd.reporters
{
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.models.Expectation;
	import pixeldroid.bdd.models.MatchResult;

	public class ConsoleReporter implements Reporter
	{
		private var numTests:Number = 0;
		private var numFailures:Number = 0;


		public function begin(name:String, total:Number):void
		{
			numTests = total;
			trace('');
			trace(name +' (' +total +' tests)');
		}

		public function report(e:Expectation, index:Number, total:Number):void
		{
			trace('should ' +e.description +' (' +(index+1) +'/' +total +')');

			var i:Number;
			var n:Number = e.numResults;
			var result:MatchResult;
			for (i = 0; i < n; i++)
			{
				result = e.getResult(i);
				if (!result.success) numFailures += 1;
				var verdict:String = result.success ? '.' : 'X';
				trace(verdict +' expect ' +result.message);
			}

		}

		public function end():void
		{
			trace('completed ' +numTests +' tests. ' +numFailures +' ' +pluralize('failure', numFailures) +'.');
		}


		private function pluralize(s:String, n:Number):String
		{
			if (n == 0 || n > 1) return s +'s';
			return s;
		}
	}
}
