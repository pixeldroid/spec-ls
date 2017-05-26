
package pixeldroid.bdd.reporters
{
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.SpecInfo;


    public class ReporterManager implements Reporter
    {
        private var reporters:Vector.<Reporter> = [];


        public function get length():Number
        {
            return reporters.length;
        }


        public function add(reporter:Reporter):void
        {
            if (reporter) reporters.push(reporter);
        }

        public function init(specInfo:SpecInfo):void
        {
            for each (var reporter:Reporter in reporters)
            {
                reporter.init(specInfo);
            }
        }

        public function begin(name:String, total:Number):void
        {
            for each (var reporter:Reporter in reporters)
            {
                reporter.begin(name, total);
            }
        }

        public function report(e:Expectation, durationSec:Number, index:Number, total:Number):void
        {
            for each (var reporter:Reporter in reporters)
            {
                reporter.report(e, durationSec, index, total);
            }
        }

        public function end(name:String, durationSec:Number):Boolean
        {
            var success:Boolean = true;

            for each (var reporter:Reporter in reporters)
            {
                if (!reporter.end(name, durationSec)) success = false;
            }

            return success;
        }
    }
}

