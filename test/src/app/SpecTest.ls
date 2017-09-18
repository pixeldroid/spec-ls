package
{
    import system.application.ConsoleApplication;
    import system.Process;

    import pixeldroid.bdd.SpecExecutor;

    import AssertionSpec;
    import CallUtilsSpec;
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
                CallUtilsSpec,
            ]);

            Process.exit(returnCode);
        }
    }

}
