package
{
    import system.application.ConsoleApplication;
    import system.Process;

    import pixeldroid.bdd.SpecExecutor;

    import MatcherSpec;
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
                MatcherSpec,
                AssertionSpec,
            ]);

            Process.exit(returnCode);
        }
    }

}
