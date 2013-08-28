
package pixeldroid.bdd
{
	import pixeldroid.bdd.Matcher;
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.models.Expectation;
	import pixeldroid.bdd.models.MatchResult;

	public class Thing
	{
		private var name:String = '<thing>';
		private var expectations:Vector.<Expectation> = [];
		private var executionLog:Vector.<String> = [];
		private var reporters:Vector.<Reporter> = [];

		public function Thing(name:String)
		{
			this.name = name;
		}


		public function should(declaration:String, validation:Function):void
		{
			expectations.push(new Expectation(declaration, validation));
		}

		public function execute(reporters:Vector.<Reporter>):void
		{
			this.reporters = reporters;
			reportProgress('');
			reportProgress(name);

			var e:Expectation;
			var i:Number;
			var n:Number = expectations.length;
			for (i = 0; i < n; i++)
			{
				e = expectations[i];
				reportProgress('should ' +e.description +' (' +(i+1) +'/' +n +')');

				// run the validation closure, which has captured this instance in its scope
				// it will call in to expects(), which will pass flow on to Matcher
				// which will call addResult()
				e.test();
			}
		}

		public function printExecutionLog():void
		{
			var i:Number;
			var n:Number = executionLog.length;
			for (i = 0; i < n; i++)
			{
				trace('[' +i +'] ' +executionLog[i]);
			}
		}


		/// used by closures
		public function expects(value:Object):Matcher
		{
			var matcher:Matcher = new Matcher(this, value);
			return matcher;
		}

		public function addResult(result:MatchResult):void
		{
			var verdict:String = result.success ? '.' : 'X';
			reportProgress(verdict +' expect ' +result.message);
		}


		private function reportProgress(message:String):void
		{
			// TODO: report and store results, not strings
			executionLog.push(message);

			var i:Number;
			var n:Number = reporters.length;
			for (i = 0; i < n; i++)
			{
				reporters[i].report(message);
			}
		}
	}
}