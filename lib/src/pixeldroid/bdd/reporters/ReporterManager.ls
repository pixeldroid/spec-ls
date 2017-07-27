
package pixeldroid.bdd.reporters
{
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.SpecInfo;


    /**
    Delegates calls to multiple individual reporters, allowing for more than one reporter to be attached to a specifier.
    */
    public class ReporterManager implements Reporter
    {
        private var reporters:Vector.<Reporter> = [];


        /** Retrieve the number of reporters currently being managed. */
        public function get length():Number
        {
            return reporters.length;
        }

        /**
        Add a reporter to the management group.

        A reporter can only be added once; this is an idempotent operation.

        @param reporter An implementer of the Reporter interface
        */
        public function add(reporter:Reporter):void
        {
            if (reporter && !reporters.contains(reporter)) reporters.push(reporter);
        }

        /**
        Remove a reporter from the management group.

        @param reporter A reference to a previously added implementer of the Reporter interface
        */
        public function remove(reporter:Reporter):void
        {
            reporters.remove(reporter);
        }

        /** @inherit */
        public function init(specInfo:SpecInfo):void
        {
            for each (var reporter:Reporter in reporters)
            {
                reporter.init(specInfo);
            }
        }

        /** @inherit */
        public function begin(name:String, total:Number):void
        {
            for each (var reporter:Reporter in reporters)
            {
                reporter.begin(name, total);
            }
        }

        /** @inherit */
        public function report(e:Expectation, durationSec:Number, index:Number, total:Number):void
        {
            for each (var reporter:Reporter in reporters)
            {
                reporter.report(e, durationSec, index, total);
            }
        }

        /** @inherit */
        public function end(name:String, durationSec:Number):Boolean
        {
            var success:Boolean = true;

            for each (var reporter:Reporter in reporters)
            {
                if (!reporter.end(name, durationSec)) success = false;
            }

            return success;
        }

        /** @inherit */
        public function finalize(durationSec:Number):void
        {
            for each (var reporter:Reporter in reporters)
            {
                reporter.finalize(durationSec);
            }
        }
    }
}

