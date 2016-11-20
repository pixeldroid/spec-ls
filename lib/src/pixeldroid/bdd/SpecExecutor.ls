package pixeldroid.bdd
{

    import system.CommandLine;
    import system.Process;
    import system.reflection.MethodInfo;
    import system.reflection.Type;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.reporters.AnsiReporter;
    import pixeldroid.bdd.reporters.ConsoleReporter;
    import pixeldroid.bdd.reporters.JunitReporter;


    public class SpecExecutor
    {
        public static const FORMAT_ANSI:String = 'ansi';
        public static const FORMAT_CONSOLE:String = 'console';
        public static const FORMAT_JUNIT:String = 'junit';

        public static var seed:Number = -1;

        private static const SUCCESS:Number = 0;
        private static const FAILURE:Number = 1;


        public static function addFormat(format:String):void
        {
            Spec.addReporter(reporterByName(format));
        }

        public static function exec(specs:Vector.<Type>):void
        {
            if (Spec.numReporters == 0) Spec.addReporter(new ConsoleReporter());

            var method:MethodInfo;
            for each(var spec:Type in specs)
            {
                method = spec.getMethodInfoByName('describe');
                Debug.assert(method, 'Could not find describe method on class' +spec.getFullName());
                method.invokeSingle(spec, null);
            }

            Process.exit(Spec.execute(seed) ? SUCCESS : FAILURE);
        }

        public static function parseArgs():void
        {
            var arg:String;
            for (var i = 0; i < CommandLine.getArgCount(); i++)
            {
                arg = CommandLine.getArg(i);
                if (arg == '--format') addFormat(CommandLine.getArg(++i));
                if (arg == '--seed') seed = Number.fromString(CommandLine.getArg(++i));
            }
        }


        private static function reporterByName(name:String):Reporter
        {
            var r:Reporter;

            switch (name.toLowerCase())
            {
                case FORMAT_ANSI:    r = new AnsiReporter();    break;
                case FORMAT_CONSOLE: r = new ConsoleReporter(); break;
                case FORMAT_JUNIT:   r = new JunitReporter();   break;
            }

            return r;
        }
    }

}
