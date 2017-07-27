
package pixeldroid.bdd
{
    import pixeldroid.bdd.Assertion;
    import pixeldroid.bdd.Matcher;
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.Thing;
    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.random.Randomizer;

    import system.platform.Platform;


    /**
    */
    public class ThingValidator
    {
        private var expectations:Vector.<Expectation>;
        private var currentExpectation:Expectation;
        private var startTimeMs:Number;


        /**
        Provide the expectations to be validated.

        @param value Vector of Expectation instances to be tested
        */
        public function setExpectations(value:Vector.<Expectation>):void { expectations = value; }

        /**
        Retrieve an assertion for the expectation currently under test.

        @param value A value to provide to the Assertion
        */
        public function getAssertion(value:Object):Assertion
        {
            var assertion:Assertion = new Assertion(currentExpectation, value);
            return assertion;
        }

        /**
        Retrieve a matcher for the expectation currently under test.

        @param value A value to provide to the Matcher
        */
        public function getMatcher(value:Object):Matcher
        {
            var matcher:Matcher = new Matcher(currentExpectation, value);
            return matcher;
        }

        /**
        Test all expectations currently defined. Progress and results will be sent to the provided reporter.

        @param reporter An implementor of the `Reporter` interface, to receive real-time progress updates and final test results
        */
        public function validate(thing:Thing, reporter:Reporter):Boolean
        {
            thing.submitForValidation(this);
            var n:Number = expectations.length;
            if (n == 0) return true;

            startTimeMs = Platform.getTime();
            Randomizer.shuffle(expectations);

            var e:Expectation;
            var i:Number;
            var ms:Number;

            reporter.begin(thing.name, n);

            for (i = 0; i < n; i++)
            {
                ms = Platform.getTime();
                currentExpectation = expectations[i];

                // run the validation closure, which has captured a Thing instance in its scope
                // it will call in to Thing.expects(),
                //   which will call getMatcher() to retrieve a Matcher linked to the current expectation
                //     which will process the assertion and call addResult() on the current expectation
                currentExpectation.test();

                if (currentExpectation.numResults == 0)
                {
                    var noop:MatchResult = new MatchResult();
                    noop.success = false;
                    noop.description = 'nothing';
                    noop.message = 'expectations must test something';
                    currentExpectation.addResult(noop);
                }

                // result is added, so can now report it
                reporter.report(currentExpectation, (Platform.getTime() - ms) * .001, i, n);
            }

            currentExpectation = null;

            return reporter.end(thing.name, (Platform.getTime() - startTimeMs) * .001);
        }

    }
}
