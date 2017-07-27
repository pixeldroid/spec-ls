package
{
    import pixeldroid.bdd.Matcher;
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
        private var peek:Vector.<Requirement>;

        override public function setRequirements(value:Vector.<Requirement>):void { peek = value; super.setRequirements(value); }
        public function get numRequirements():Number { return peek.length; }
    }
}
