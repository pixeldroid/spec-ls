
package pixeldroid.bdd.reporters
{
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.bdd.models.SpecInfo;


    /**
    Prints results of executing a specification to the console using a simple human readable format:

    ```
    [Spec v2.0.0] seed: 63134

    Thing1
     -should be versioned
    . expect '2.0.0' toPatternMatch '(%d+).(%d+).(%d+)' with 3 capture groups
     -should fail specifications whose expectations lack assertions
    . expect false toBeFalsey
    0 failures in 2 assertions from 2 expectations. 0.001s.

    Thing2
     -should be readable
    X expect false toBeTruthy (./src/spec//Thing2Spec.ls:23)
    . expect true toBeTruthy
    1 failure in 2 assertions from 1 expectation. 0.001s.

    1 failure in 4 assertions from 3 expectations.
    completed in 0.002s.
    ```
    */
    public class ConsoleReporter implements Reporter
    {
        private var totalFailures:Number;
        private var totalAsserts:Number;
        private var totalExpects:Number;

        private var numFailures:Number;
        private var numAssert:Number;
        private var numExpect:Number;


        /** @inherit */
        public function init(specInfo:SpecInfo):void
        {
            totalFailures = 0;
            totalAsserts = 0;
            totalExpects = 0;

            trace('');
            trace(specInfo);
        }

        /** @inherit */
        public function begin(name:String, total:Number):void
        {
            numFailures = 0;
            numAssert = 0;
            numExpect = total;

            trace('');
            trace(name);
        }

        /** @inherit */
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

        /** @inherit */
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

        /** @inherit */
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
