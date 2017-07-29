package
{
    import system.application.ConsoleApplication;
    import system.Process;

    import pixeldroid.bdd.SpecExecutor;

    import AssertionSpec;
    import CallUtilSpec;
    import ExpectationSpec;
    import SpecSpec;
    import ThingSpec;


    public class SpecTest extends ConsoleApplication
    {
        override public function run():void
        {
            SpecExecutor.parseArgs();

            var returnCode:Number = SpecExecutor.exec([
                SpecSpec,
                ThingSpec,
                ExpectationSpec,
                AssertionSpec,
                CallUtilSpec,
            ]);

            Process.exit(returnCode);
        }
    }

}
