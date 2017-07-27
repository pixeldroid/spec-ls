
package pixeldroid.bdd.reporters
{
    import pixeldroid.ansi.ANSI;
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Requirement;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.bdd.models.SpecInfo;


    /**
    Prints results of executing a specification to the console using ANSI codes for colored formatting.

    The format is compact:

    ```
    [Spec v2.0.0] seed: 36440

    Thing1 ...........................X.........................
    ........

     1 failure in 61 expectations from 10 requirements. 0.025s.
     "should be readable" expected false toBeTruthy but value is not truthy.
      ./src/spec//Thing1Spec.ls:123

    Thing2 ....

     0 failures in 4 expectations from 3 requirements. 0.001s.

    1 failure in 65 expectations from 13 requirements.
    completed in 0.026s.
    ```
    */
    public class AnsiReporter implements Reporter
    {
        private const lineWidth:Number = 60;

        private var totalFailures:Number;
        private var totalExpects:Number;
        private var totalReqs:Number;

        private var failures:Dictionary.<Requirement, Vector.<Number>>;
        private var numExpect:Number;
        private var numReq:Number;

        private var ansi:ANSI = new ANSI();
        private var progress:String;
        private var numChars:Number;


        /** @inherit */
        public function init(specInfo:SpecInfo):void
        {
            totalFailures = 0;
            totalExpects = 0;
            totalReqs = 0;

            trace('');

            ansi.clear;
            ansi.faint.add('[').nofaint.add(specInfo.name +' v' +specInfo.version).faint.add(']');
            ansi.add(' seed: ').nofaint.fgCyan.add(specInfo.seed.toString()).reset;

            trace(ansi);
        }

        /** @inherit */
        public function begin(name:String, total:Number):void
        {
            failures = {};
            numExpect = 0;
            numReq = total;

            progress = ansi.clear.bold.add(name).nobold.add(' ').toString();
            numChars = name.length + 1;

            trace('');
            trace(''); // overwriting will start on this line
        }

        /** @inherit */
        public function report(req:Requirement, durationSec:Number, index:Number, total:Number):void
        {
            var i:Number;
            var n:Number = req.numResults;
            var result:MatchResult;

            numExpect += n;

            for (i = 0; i < n; i++)
            {
                ansi.clear.add(progress);

                result = req.getResult(i);
                if (result.success)
                {
                    ansi.faint.add('.').nofaint;
                    numChars++;
                }
                else
                {
                    if (failures[req]) failures[req].push(i);
                    else failures[req] = [i];

                    ansi.bold.fgRed.add('X').nofg.nobold;
                    numChars++;
                }

                progress = ansi.toString();
                trace(ansi.clear.overwrite.add(progress));

                if (numChars > lineWidth)
                {
                    numChars = 0;
                    progress = '';
                    trace(''); // overwriting will continue on this new line
                }
            }
        }

        /** @inherit */
        public function end(name:String, durationSec:Number):Boolean
        {
            var failMessages:Vector.<String> = collectFailures();
            var numFailures:Number = failMessages.length;
            var success:Boolean = (numFailures == 0);

            trace('');

            ansi.clear;
            if (success) ansi.fgGreen;
            else ansi.bold.fgRed;

            ansi.add(' ' +numFailures +' ' +pluralize('failure', numFailures)).reset;
            ansi.faint.add(' in ').nofaint.add(numExpect +' ' +pluralize('expectation', numExpect));
            ansi.faint.add(' from ').nofaint.add(numReq +' ' +pluralize('requirement', numReq));
            ansi.faint.add('. ' +durationSec +'s.').reset;

            trace(ansi);
            for each (var s:String in failMessages) trace(s);

            totalFailures += numFailures;
            totalExpects += numExpect;
            totalReqs += numReq;

            return success;
        }

        /** @inherit */
        public function finalize(durationSec:Number):void
        {
            trace('');

            ansi.clear;
            ansi.faint.add(totalFailures +' ' +pluralize('failure', totalFailures));
            ansi.faint.add(' in ' +totalExpects +' ' +pluralize('expectation', totalExpects));
            ansi.faint.add(' from ' +totalReqs +' ' +pluralize('requirement', totalReqs));
            ansi.faint.add('.').reset;
            trace(ansi);

            ansi.clear;
            ansi.faint.add('completed in ' +durationSec +'s.').reset;
            trace(ansi);
        }


        private function collectFailures():Vector.<String>
        {
            var v:Vector.<String> = [];
            var result:MatchResult;

            for (var req:Requirement in failures)
            {
                var resultIndices:Vector.<Number> = failures[req];
                for each (var i:Number in resultIndices)
                {
                    result = req.getResult(i);
                    ansi.clear.fgRed.add(' "' +req.description +'" ').faint.add('expected ').nofaint.add(result.description).reset;
                    if (result.hasMessage()) ansi.fgRed.faint.add(' but ').nofaint.add(result.message).reset;
                    if (result.source) ansi.fgRed.faint.add('\n  ' +result.source +':' +result.line).reset;
                    v.push(ansi.toString());
                }
            }

            return v;
        }

        private function pluralize(s:String, n:Number):String
        {
            if (n == 0 || n > 1) return s +'s';
            return s;
        }
    }
}
