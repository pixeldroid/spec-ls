package
{
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import ExpectationSpec;
    import SpecSpec;


    public class SpecTest extends ConsoleApplication
    {
        override public function run():void
        {
            SpecExecutor.parseArgs();

            SpecExecutor.exec([
                ExpectationSpec,
                SpecSpec
            ]);
        }
    }

}
