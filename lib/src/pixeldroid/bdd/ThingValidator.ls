
package pixeldroid.bdd
{
    import pixeldroid.bdd.Assertion;
    import pixeldroid.bdd.Matcher;
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.Thing;
    import pixeldroid.bdd.models.Requirement;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.random.Randomizer;

    import system.platform.Platform;


    /**
    */
    public class ThingValidator
    {
        private var requirements:Vector.<Requirement>;
        private var currentRequirement:Requirement;
        private var startTimeMs:Number;


        /**
        Provide the requirements to be validated.

        @param value Vector of Requirement instances to be tested
        */
        public function setRequirements(value:Vector.<Requirement>):void { requirements = value; }

        /**
        Retrieve an assertion for the requirement currently under validation.

        @param value A value to provide to the Assertion
        */
        public function getAssertion(value:Object):Assertion
        {
            var assertion:Assertion = new Assertion(currentRequirement, value);
            return assertion;
        }

        /**
        Retrieve a matcher for the requirement currently under validation.

        @param value A value to provide to the Matcher
        */
        public function getMatcher(value:Object):Matcher
        {
            var matcher:Matcher = new Matcher(currentRequirement, value);
            return matcher;
        }

        /**
        Test all requirements currently described. Progress and results will be sent to the provided reporter.

        @param reporter An implementor of the `Reporter` interface, to receive real-time progress updates and final test results
        */
        public function validate(thing:Thing, reporter:Reporter):Boolean
        {
            thing.submitForValidation(this);
            var n:Number = requirements.length;
            if (n == 0) return true;

            startTimeMs = Platform.getTime();
            Randomizer.shuffle(requirements);

            var i:Number;
            var ms:Number;

            reporter.begin(thing.name, n);

            for (i = 0; i < n; i++)
            {
                ms = Platform.getTime();
                currentRequirement = requirements[i];

                // run the validation closure `.test()`, which has captured a Thing instance in its scope
                // it will call in to Thing.expects(),
                //   which will call getMatcher() to retrieve a Matcher linked to the current requirement
                //     which will process the expectation and call addResult() on the current requirement
                currentRequirement.test();

                if (currentRequirement.numResults == 0)
                {
                    var noop:MatchResult = new MatchResult();
                    noop.success = false;
                    noop.description = 'nothing';
                    noop.message = 'requirements must test something';
                    currentRequirement.addResult(noop);
                }

                // result is added, so can now report it
                reporter.report(currentRequirement, (Platform.getTime() - ms) * .001, i, n);
            }

            currentRequirement = null;

            return reporter.end(thing.name, (Platform.getTime() - startTimeMs) * .001);
        }

    }
}
