
package
{

    import system.application.ConsoleApplication;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.reporters.ConsoleReporter;

    import ExpectationSpec;
    import SpecSpec;


    public class TestSpec extends ConsoleApplication
    {
        override public function run():void
        {
            SpecSpec.describe();
            ExpectationSpec.describe();

            Spec.addReporter(new ConsoleReporter());
            Spec.execute();
        }
    }
}