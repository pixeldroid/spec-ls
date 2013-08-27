
package pixeldroid.bdd
{
	import pixeldroid.bdd.Matcher;
	import pixeldroid.bdd.models.Expectation;
	import pixeldroid.bdd.models.MatchResult;

	public class Thing
	{
		private var name:String = '<thing>';
		private var expectations:Vector.<Expectation> = [];
		private var executionLog:Vector.<String> = [];

		public function Thing(name:String)
		{
			this.name = name;
		}


		public function should(declaration:String, validation:Function):void
		{
			expectations.push(new Expectation(declaration, validation));
		}

		public function execute():void
		{
			var e:Expectation;

			var i:Number;
			var n:Number = expectations.length;
			for (i = 0; i < n; i++)
			{
				e = expectations[i];
				executionLog.push(name +' should ' +e.description);
				e.test(); // runs the closure, which has captured calls to expects() above
			}
		}

		public function printExecutionLog():void
		{
			var i:Number;
			var n:Number = executionLog.length;
			for (i = 0; i < n; i++)
			{
				trace(executionLog[i]);
				//trace('[' +i +'] ' +executionLog[i]);
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
			executionLog.push('  ' +verdict +' expect ' +result.message);
		}
	}
}