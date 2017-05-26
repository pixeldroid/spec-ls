package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.bdd.Reporter;


    public static class SpecSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('Spec');

            it.should('be versioned', be_versioned);
            it.should('define specifications', define_specifications);
            it.should('fail specifications whose expectations lack assertions', fail_empty_specs);
            it.should('support custom reporters via an api', support_reporters);
        }


        private static function be_versioned():void
        {
            it.expects(Spec.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
        }

        private static function define_specifications():void
        {
            var testSpec:Spec = new Spec();
            it.expects(testSpec.describe('Test')).toBeA(Thing);
        }

        private static function fail_empty_specs():void
        {
            var testSpec:Spec = new Spec();
            testSpec.addReporter(new TestReporter());

            var test:Thing = testSpec.describe('Test');
            test.should('fail empty specs', function() {});

            it.expects(testSpec.execute()).toBeFalsey();
        }

        private static function support_reporters():void
        {
            var testSpec:Spec = new Spec();
            var testReporter:TestReporter = new TestReporter();
            testSpec.addReporter(testReporter);

            var test:Thing = testSpec.describe('Test');
            test.should('exercise the reporter api', function() {
                test.expects(testReporter).toBeA(Reporter);
            });

            it.expects(testSpec.execute()).toBeTruthy();

            var apiCalled:Boolean =
                testReporter.called['init']
                && testReporter.called['begin']
                && testReporter.called['report']
                && testReporter.called['end'];
            it.expects(apiCalled).toBeTruthy();
        }
    }

    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.bdd.models.SpecInfo;

    private class TestReporter implements Reporter
    {
        private var numFailures:Number = 0;
        public var called:Dictionary.<String, Boolean> = {
            'init': false,
            'begin': false,
            'report': false,
            'end': false
        };
        public function init(specInfo:SpecInfo):void { called['init'] = true; }
        public function begin(name:String, total:Number):void { called['begin'] = true; }
        public function report(e:Expectation, durationSec:Number, index:Number, total:Number):void
        {
            called['report'] = true;
            var i:Number;
            var n:Number = e.numResults;
            var result:MatchResult;
            for (i = 0; i < n; i++)
            {
                result = e.getResult(i);
                if (!result.success) numFailures++;
            }
        }
        public function end(name:String, duration:Number):Boolean
        {
            called['end'] = true;
            return (numFailures == 0);
        }
    }
}
