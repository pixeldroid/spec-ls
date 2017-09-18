package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;


    public static class AssertionSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('Assertion');
            Assertion.asserter = new TestAsserter();

            it.should('provide a numberness assertion', provide_numberness_assertion);
            it.should('provide nullness assertions', provide_nullness_assertions);
            it.should('provide emptiness assertions', provide_emptiness_assertions);
            it.should('provide equality assertions', provide_equality_assertions);
            it.should('provide inequality assertions', provide_inequality_assertions);
            it.should('provide a type assertion', provide_type_assertion);
        }


        private static function provide_numberness_assertion():void
        {
            it.expects( it.asserts(NaN).isNotNaN().or('') ).toBeFalsey();
            it.expects( it.asserts(null).isNotNaN().or('') ).toBeTruthy();
            it.expects( it.asserts(false).isNotNaN().or('') ).toBeTruthy();
            it.expects( it.asserts(0).isNotNaN().or('') ).toBeTruthy();
            it.expects( it.asserts(123.45).isNotNaN().or('') ).toBeTruthy();
            it.expects( it.asserts('').isNotNaN().or('') ).toBeTruthy();
        }

        private static function provide_nullness_assertions():void
        {
            it.expects( it.asserts(null).isNull().or('') ).toBeTruthy();
            it.expects( it.asserts(false).isNull().or('') ).toBeFalsey();
            it.expects( it.asserts(NaN).isNull().or('') ).toBeFalsey();
            it.expects( it.asserts(0).isNull().or('') ).toBeFalsey();
            it.expects( it.asserts('').isNull().or('') ).toBeFalsey();

            it.expects( it.asserts(null).isNotNull().or('') ).toBeFalsey();
            it.expects( it.asserts(false).isNotNull().or('') ).toBeTruthy();
            it.expects( it.asserts(NaN).isNotNull().or('') ).toBeTruthy();
            it.expects( it.asserts(0).isNotNull().or('') ).toBeTruthy();
            it.expects( it.asserts('').isNotNull().or('') ).toBeTruthy();

        }

        private static function provide_emptiness_assertions():void
        {
            it.expects( it.asserts('').isEmpty().or('') ).toBeTruthy();
            it.expects( it.asserts([]).isEmpty().or('') ).toBeTruthy();
            // it.expects( it.asserts({}).isEmpty().or('') ).toBeTruthy(); // TODO: add empty dictionaries
            it.expects( it.asserts('abc').isEmpty().or('') ).toBeFalsey();
            it.expects( it.asserts([1,2]).isEmpty().or('') ).toBeFalsey();

            it.expects( it.asserts('').isNotEmpty().or('') ).toBeFalsey();
            it.expects( it.asserts([]).isNotEmpty().or('') ).toBeFalsey();
            it.expects( it.asserts('abc').isNotEmpty().or('') ).toBeTruthy();
            it.expects( it.asserts([1,2]).isNotEmpty().or('') ).toBeTruthy();

            it.expects( it.asserts(null).isEmpty().or('') ).toBeFalsey();
            it.expects( it.asserts(false).isEmpty().or('') ).toBeFalsey();
            it.expects( it.asserts(NaN).isEmpty().or('') ).toBeFalsey();
            it.expects( it.asserts(0).isEmpty().or('') ).toBeFalsey();
        }

        private static function provide_equality_assertions():void
        {
            it.expects( it.asserts(!false).isEqualTo(!!true).or('') ).toBeTruthy();
            it.expects( it.asserts(6 + 5).isEqualTo(11).or('') ).toBeTruthy();
            it.expects( it.asserts('three'.length).isEqualTo(5).or('') ).toBeTruthy();

            it.expects( it.asserts(false).isNotEqualTo(true).or('') ).toBeTruthy();
            it.expects( it.asserts(6 * 5).isNotEqualTo(11).or('') ).toBeTruthy();
            it.expects( it.asserts('three'.length).isNotEqualTo(3).or('') ).toBeTruthy();
        }

        private static function provide_inequality_assertions():void
        {
            it.expects( it.asserts('seven'.length).isGreaterThan('ten'.length).or('') ).toBeTruthy();
            it.expects( it.asserts('six'.length).isLessThan('three'.length).or('') ).toBeTruthy();
        }

        private static function provide_type_assertion():void
        {
            it.expects( it.asserts(true).isTypeOf(Boolean).or('') ).toBeTruthy();
            it.expects( it.asserts(9).isTypeOf(Number).or('') ).toBeTruthy();
            it.expects( it.asserts('').isTypeOf(String).or('') ).toBeTruthy();
            it.expects( it.asserts([]).isTypeOf(Vector).or('') ).toBeTruthy();
            it.expects( it.asserts({}).isTypeOf(Dictionary).or('') ).toBeTruthy();
            it.expects( it.asserts(function(){}).isTypeOf(Function).or('') ).toBeTruthy();
            it.expects( it.asserts(it).isTypeOf(Thing).or('') ).toBeTruthy();
            it.expects( it.asserts(it).isTypeOf(Object).or('') ).toBeTruthy();
        }

    }

    import pixeldroid.bdd.Assertion;
    import pixeldroid.bdd.Asserter;

    private class TestAsserter implements Asserter
    {
        public var condition:Boolean;
        public var source:String;
        public var line:Number;

        public function init(condition:Boolean, source:String, line:Number):void
        {
            this.condition = condition;
            this.source = source;
            this.line = line;
        }

        public function or(message:String):Boolean
        {
            if (condition)
                return true;

            return false;
        }
    }
}
