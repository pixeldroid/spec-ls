package
{
    import pixeldroid.bdd.Assertion;
    import pixeldroid.bdd.Expectation;
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;
    import pixeldroid.bdd.models.Requirement;


    public static class ThingSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('Thing');

            it.should('describe behavior', describe_behavior);
            it.should('create matchers to validate requirements', create_matchers);
            it.should('validate via execution of real code', be_executable);
        }


        private static function describe_behavior():void
        {
            var testSpec:Spec = new Spec();
            var test:Thing = testSpec.describe('Test');
            var validator:TestValidator = new TestValidator();
            test.submitForValidation(validator);

            it.expects(validator.numRequirements).toEqual(0);
            test.should('create requirements out of declaration,validation pairs', function() {});
            it.expects(validator.numRequirements).toEqual(1);
        }

        private static function create_matchers():void
        {
            var testSpec:Spec = new Spec();
            var test:Thing = testSpec.describe('Test');
            var validator:TestValidator = new TestValidator();
            test.submitForValidation(validator);

            var expectation:Object;
            var assertion:Object;
            var value:Number = 123;

            test.should('create Expectations and Assertions during validation', function() {
                expectation = test.expects(value);
                assertion = test.asserts(value);
            });
            validator.validate(test, new MockReporter());

            it.expects(expectation).toBeA(Expectation);
            it.expects(assertion).toBeA(Assertion);
        }

        private static function be_executable():void
        {
            var f:Function = function(a:Number,b:Number):Number { return a*b; };
            it.expects(f(5,7)).toEqual(5*7);
        }
    }


    import pixeldroid.bdd.ThingValidator;

    private class TestValidator extends ThingValidator
    {
        private var peek:Vector.<Requirement>;

        override public function setRequirements(value:Vector.<Requirement>):void { peek = value; super.setRequirements(value); }
        public function get numRequirements():Number { return peek.length; }
    }


    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Requirement;
    import pixeldroid.bdd.models.SpecInfo;

    private class MockReporter implements Reporter
    {
        public function init(specInfo:SpecInfo):void {}
        public function begin(name:String, total:Number):void {}
        public function report(requirement:Requirement, durationSec:Number, index:Number, total:Number):void {}
        public function end(name:String, durationSec:Number):Boolean { return true; }
        public function finalize(durationSec:Number):void {}
    }
}
