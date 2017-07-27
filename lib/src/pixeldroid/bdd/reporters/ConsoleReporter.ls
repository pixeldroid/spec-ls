
package pixeldroid.bdd.reporters
{
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Requirement;
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
    0 failures in 2 expectations from 2 requirements. 0.001s.

    Thing2
     -should be readable
    X expect false toBeTruthy (./src/spec//Thing2Spec.ls:23)
    . expect true toBeTruthy
    1 failure in 2 expectations from 1 requirement. 0.001s.

    1 failure in 4 expectations from 3 requirements.
    completed in 0.002s.
    ```
    */
    public class ConsoleReporter implements Reporter
    {
        private var totalFailures:Number;
        private var totalExpects:Number;
        private var totalReqs:Number;

        private var numFailures:Number;
        private var numExpect:Number;
        private var numReq:Number;


        /** @inherit */
        public function init(specInfo:SpecInfo):void
        {
            totalFailures = 0;
            totalExpects = 0;
            totalReqs = 0;

            trace('');
            trace(specInfo);
        }

        /** @inherit */
        public function begin(name:String, total:Number):void
        {
            numFailures = 0;
            numExpect = 0;
            numReq = total;

            trace('');
            trace(name);
        }

        /** @inherit */
        public function report(req:Requirement, durationSec:Number, index:Number, total:Number):void
        {
            trace(' -should ' +req.description);

            var i:Number;
            var n:Number = req.numResults;
            var result:MatchResult;
            var verdict:String;

            numExpect += n;

            for (i = 0; i < n; i++)
            {
                result = req.getResult(i);
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
            summary += ' in ' +numExpect +' ' +pluralize('expectation', numExpect);
            summary += ' from ' +numReq +' ' +pluralize('requirement', numReq);
            summary += '.';
            summary += ' ' +durationSec +'s.';

            trace(summary);

            totalFailures += numFailures;
            totalExpects += numExpect;
            totalReqs += numReq;

            return (numFailures == 0);
        }

        /** @inherit */
        public function finalize(durationSec:Number):void
        {
            var summary:String = '';
            summary += totalFailures +' ' +pluralize('failure', totalFailures);
            summary += ' in ' +totalExpects +' ' +pluralize('expectation', totalExpects);
            summary += ' from ' +totalReqs +' ' +pluralize('requirement', totalReqs);
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
