
package pixeldroid.bdd.reporters
{
	import pixeldroid.bdd.Reporter;

	public class ConsoleReporter implements Reporter
	{
		public function report(message:String):void
		{
			trace(message);
		}
	}
}
