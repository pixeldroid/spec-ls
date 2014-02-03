
package
{

	import system.application.ConsoleApplication;

	import pixeldroid.bdd.Spec;
	import pixeldroid.bdd.reporters.AnsiReporter;
	import pixeldroid.bdd.reporters.ConsoleReporter;
	import pixeldroid.bdd.reporters.JunitReporter;

	import ExpectationSpec;
	import SpecSpec;


	public class SpecTest extends ConsoleApplication
	{
		override public function run():void
		{
			SpecSpec.describe();
			ExpectationSpec.describe();

			//Spec.addReporter(new ConsoleReporter());
			Spec.addReporter(new AnsiReporter());
			Spec.addReporter(new JunitReporter());
			Spec.execute();
		}
	}
}