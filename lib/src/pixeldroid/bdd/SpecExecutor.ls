package pixeldroid.bdd
{

    import system.CommandLine;
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

        public static const SPECIFIER_METHOD:String = 'specify';

        public static var seed:Number = -1;

        private static const SUCCESS:Number = 0;
        private static const FAILURE:Number = 1;

        private static var _specifier:Spec;


        public static function addFormat(format:String):void
        {
            var spec:Spec = specifier;
            spec.addReporter(reporterByName(format));
        }

        public static function exec(specs:Vector.<Type>):Number
        {
            var spec:Spec = specifier;
            if (spec.numReporters == 0) spec.addReporter(reporterByName(FORMAT_CONSOLE));

            var method:MethodInfo;
            for each(var type:Type in specs)
            {
                method = type.getMethodInfoByName(SPECIFIER_METHOD);
                Debug.assert(method, 'Could not find method named "' +SPECIFIER_METHOD +'" on class ' +type.getFullName());
                method.invokeSingle(type, spec);
            }

            return spec.execute(seed) ? SUCCESS : FAILURE;
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


        private static function get specifier():Spec
        {
            if (!_specifier) _specifier = new Spec();
            return _specifier;
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
