package
{
    import system.application.ConsoleApplication;
    import system.Process;

    import pixeldroid.bdd.SpecExecutor;

    import ExpectationSpec;
    import SpecSpec;


    public class SpecTest extends ConsoleApplication
    {
        override public function run():void
        {
            SpecExecutor.parseArgs();

            var returnCode:Number = SpecExecutor.exec([
                ExpectationSpec,
                SpecSpec
            ]);

            Process.exit(returnCode);
        }
    }

}
