
package pixeldroid.bdd
{

    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.Thing;
    import pixeldroid.bdd.models.SpecInfo;
    import pixeldroid.bdd.reporters.ReporterManager;
    import pixeldroid.random.Randomizer;

    public class Spec
    {
        public static const version:String = '2.0.0';

        private const things:Vector.<Thing> = [];
        private const reporters:ReporterManager = new ReporterManager();

        public function Spec() { }


        public function describe(thingName:String):Thing
        {
            var thing:Thing = new Thing(thingName);
            things.push(thing);

            return thing;
        }

        public function addReporter(reporter:Reporter):void
        {
            if (reporter) reporters.add(reporter);
        }

        public function get numReporters():Number
        {
            return reporters.length;
        }

        public function execute(seed:Number=-1):Boolean
        {
            seed = Randomizer.initialize(seed);
            Randomizer.shuffle(things);

            var success:Boolean = true;

            reporters.init(new SpecInfo('Spec', version, seed));

            var i:Number;
            var n:Number = things.length;
            for(i = 0; i < n; i++)
            {
                if (!things[i].execute(reporters)) success = false;
            }

            return success;
        }

    }
}
