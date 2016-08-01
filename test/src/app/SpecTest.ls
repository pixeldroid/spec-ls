
package
{

    import system.application.ConsoleApplication;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.reporters.AnsiReporter;
    import pixeldroid.bdd.reporters.ConsoleReporter;
    import pixeldroid.bdd.reporters.JunitReporter;

    import ExpectationSpec;
    import SpecSpec;


    public class SpecTest extends ConsoleApplication
    {
        private var seed:Number = -1;

        override public function run():void
        {
            SpecSpec.describe();
            ExpectationSpec.describe();

            parseArgs();

            Spec.execute(seed);
        }

        private function parseArgs():void
        {
            var arg:String;
            for (var i = 0; i < CommandLine.getArgCount(); i++)
            {
                arg = CommandLine.getArg(i);
                if (arg == '--format') Spec.addReporter(reporterByName(CommandLine.getArg(++i)));
                if (arg == '--seed') seed = Number.fromString(CommandLine.getArg(++i));
            }

            if (Spec.numReporters == 0) Spec.addReporter(new ConsoleReporter());
        }

        private function reporterByName(name:String):Reporter
        {
            var r:Reporter;

            switch (name.toLowerCase())
            {
                case 'ansi': r = new AnsiReporter(); break;
                case 'console': r = new ConsoleReporter(); break;
                case 'junit': r = new JunitReporter(); break;
            }

            return r;
        }
    }
}
