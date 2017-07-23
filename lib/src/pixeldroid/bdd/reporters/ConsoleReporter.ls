
package pixeldroid.bdd.reporters
{
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.bdd.models.SpecInfo;


    public class ConsoleReporter implements Reporter
    {
        private var totalFailures:Number;
        private var totalAsserts:Number;
        private var totalExpects:Number;

        private var numFailures:Number;
        private var numAssert:Number;
        private var numExpect:Number;


        public function init(specInfo:SpecInfo):void
        {
            totalFailures = 0;
            totalAsserts = 0;
            totalExpects = 0;

            trace('');
            trace(specInfo);
        }

        public function begin(name:String, total:Number):void
        {
            numFailures = 0;
            numAssert = 0;
            numExpect = total;

            trace('');
            trace(name);
        }

        public function report(e:Expectation, durationSec:Number, index:Number, total:Number):void
        {
            trace(' -should ' +e.description);

            var i:Number;
            var n:Number = e.numResults;
            var result:MatchResult;
            var verdict:String;

            numAssert += n;

            for (i = 0; i < n; i++)
            {
                result = e.getResult(i);
                if (result.success)
                {
                    verdict = '.';
                }
                else
                {
                    verdict = 'X';
                    numFailures++;
                }

                trace(verdict +' expect ' +result.description);
                if (!result.success) trace('  ' +result.message, '(' +result.source +':' +result.line +')');
            }

        }

        public function end(name:String, durationSec:Number):Boolean
        {
            var summary:String = '';
            summary += numFailures +' ' +pluralize('failure', numFailures);
            summary += ' in ' +numAssert +' ' +pluralize('assertion', numAssert);
            summary += ' from ' +numExpect +' ' +pluralize('expectation', numExpect);
            summary += '.';
            summary += ' ' +durationSec +'s.';

            trace(summary);

            totalFailures += numFailures;
            totalAsserts += numAssert;
            totalExpects += numExpect;

            return (numFailures == 0);
        }

        public function finalize(durationSec:Number):void
        {
            var summary:String = '';
            summary += totalFailures +' ' +pluralize('failure', totalFailures);
            summary += ' in ' +totalAsserts +' ' +pluralize('assertion', totalAsserts);
            summary += ' from ' +totalExpects +' ' +pluralize('expectation', totalExpects);
            summary += '.';

            trace('');
            trace(summary);
            trace('completed in ' +durationSec +'s.');
        }


        private function pluralize(s:String, n:Number):String
        {
            if (n == 0 || n > 1) return s +'s';
            return s;
        }
    }
}
