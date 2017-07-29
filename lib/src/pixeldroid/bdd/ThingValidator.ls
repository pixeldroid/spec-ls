
package pixeldroid.bdd
{
    import pixeldroid.bdd.Assertion;
    import pixeldroid.bdd.Expectation;
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.Thing;
    import pixeldroid.bdd.models.Requirement;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.random.Randomizer;

    import system.CallStackInfo;
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
        @param csi Reflection info for the calling validation method
        */
        public function getAssertion(value:Object, csi:CallStackInfo):Assertion
        {
            Debug.assert(currentRequirement, 'requirement must be declared via should() prior to calling asserts()');
            currentRequirement.currentCallInfo = csi;

            var assertion:Assertion = new Assertion(currentRequirement, value);
            return assertion;
        }

        /**
        Retrieve an expectation for the requirement currently under validation.

        @param value A value to provide to the Expectation
        @param csi Reflection info for the calling validation method
        */
        public function getExpectation(value:Object, csi:CallStackInfo):Expectation
        {
            Debug.assert(currentRequirement, 'requirement must be declared via should() prior to calling expects()');
            currentRequirement.currentCallInfo = csi;

            var expectation:Expectation = new Expectation(currentRequirement, value);
            return expectation;
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
                //   which will call getExpectation() to retrieve an Expectation linked to the current requirement
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
