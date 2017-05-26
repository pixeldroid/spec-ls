package
{
    import pixeldroid.bdd.Matcher;
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;
    import pixeldroid.bdd.models.Expectation;


    public static class ThingSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('Thing');

            it.should('describe behavior', describe_behavior);
            it.should('create matchers to assert expectations', create_matchers);
            it.should('validate execution of real code', be_executable);
        }


        private static function describe_behavior():void
        {
            var testSpec:Spec = new Spec();
            var test:Thing = testSpec.describe('Test');
            var validator:TestValidator = new TestValidator();
            test.submitForValidation(validator);

            it.expects(validator.numExpectations).toEqual(0);
            test.should('create expectations out of declaration,validation pairs', function() {});
            it.expects(validator.numExpectations).toEqual(1);
        }

        private static function create_matchers():void
        {
            var testSpec:Spec = new Spec();
            var test:Thing = testSpec.describe('Test');
            var validator:TestValidator = new TestValidator();
            test.submitForValidation(validator);

            var value:Number = 123;
            it.expects(test.expects(value)).toBeA(Matcher);
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
        private var peek:Vector.<Expectation>;

        override public function setExpectations(value:Vector.<Expectation>):void { peek = value; super.setExpectations(value); }
        public function get numExpectations():Number { return peek.length; }
    }
}
