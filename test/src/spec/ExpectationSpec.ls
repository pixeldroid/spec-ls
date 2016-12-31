package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;


    public static class ExpectationSpec
    {
        private static const it:Thing = Spec.describe('Expectations');

        public static function describe():void
        {
            it.should('be executable', be_executable);
            it.should('provide boolean matchers', provide_boolean_matchers);
            it.should('provide a negation helper', provide_negation_helper);
            it.should('provide an equality matcher', provide_equality_matcher);
            it.should('provide inequality matchers', provide_inequality_matchers);
            it.should('provide a range matcher', provide_range_matcher);
            it.should('provide a null matcher', provide_null_matcher);
            it.should('provide an empty matcher', provide_empty_matcher);
            it.should('provide membership matchers', provide_membership_matchers);
            it.should('provide a pattern matcher', provide_pattern_matcher);
            it.should('provide a type matcher', provide_type_matcher);
        }


        private static function be_executable():void
        {
            var f:Function = function(a:Number,b:Number):Number { return a*b; };
            it.expects(f(5,7)).toEqual(5*7);
        }

        private static function provide_boolean_matchers():void
        {
            it.expects(true).toBeTruthy();
            it.expects(1).toBeTruthy();
            it.expects('a').toBeTruthy();
            it.expects({}).toBeTruthy();
            it.expects(function() {}).toBeTruthy();

            it.expects(false).toBeFalsey();
            it.expects(0).toBeFalsey();
            it.expects('').toBeFalsey();
            it.expects(null).toBeFalsey();
            it.expects(NaN).toBeFalsey();
        }

        private static function provide_negation_helper():void
        {
            it.expects(false).not.toBeTruthy();
            it.expects(true).not.toBeFalsey();
            it.expects(false).not.not.toBeFalsey();
            it.expects(true).not.not.toBeTruthy();
        }

        private static function provide_equality_matcher():void
        {
            it.expects(true).toEqual(true);
            it.expects(false).not.toEqual(true);
            it.expects(1).toEqual(1);
            it.expects(2).not.toEqual(1);
            it.expects('a').toEqual('a');
            it.expects('A').not.toEqual('a');

            var d:Dictionary = {};
            it.expects(d).toEqual(d);
            it.expects(d).not.toEqual({});
            it.expects({}).not.toEqual({});
        }

        private static function provide_inequality_matchers():void
        {
            it.expects(3).toBeLessThan(5);
            it.expects(3).not.toBeLessThan(0);
            it.expects(3).toBeGreaterThan(-5);
            it.expects(3).not.toBeGreaterThan(3);
        }

        private static function provide_range_matcher():void
        {
            it.expects(-3).toBePlusOrMinus(5).from(0);
            it.expects(3).not.toBePlusOrMinus(2).from(0);
        }

        private static function provide_null_matcher():void
        {
            it.expects(null).toBeNull();
            it.expects(0).not.toBeNull();
            it.expects('').not.toBeNull();
            it.expects(NaN).not.toBeNull();
        }

        private static function provide_empty_matcher():void
        {
            it.expects([]).toBeEmpty();
            it.expects('').toBeEmpty();
            it.expects([1,2,3]).not.toBeEmpty();
            it.expects('abc').not.toBeEmpty();
        }

        private static function provide_membership_matchers():void
        {
            var v:Vector.<String> = ['a', 'b', 'c'];
            it.expects(v).toContain('b');
            it.expects(v).not.toContain('q');

            var s:String = 'abc';
            it.expects(s).toContain('b');
            it.expects(s).not.toContain('q');

            s = 'the quick brown fox';
            it.expects(s).toContain('brown');
            it.expects(s).not.toContain('dog');

            it.expects(s).toStartWith('the qui');
            it.expects(s).toEndWith('own fox');
        }

        private static function provide_pattern_matcher():void
        {
            it.expects('missing groups').not.toPatternMatch('.*');
            it.expects('one or more groups').toPatternMatch('(.*)%s', 1);
            it.expects('one or more groups').toPatternMatch('(.*)%s(.*)', 2);
            it.expects('one or more groups').toPatternMatch('(.*)%s(.*)%s(.*)', 3);
            it.expects('01/02/1234').toPatternMatch('(%d+)/(%d+)/(%d+)', 3);
            it.expects('#ff0000 red').toPatternMatch('^#?(%x+)%s.*$');
            it.expects('name@company.com').toPatternMatch('^(.+@.+%..+)$');
        }

        private static function provide_type_matcher():void
        {
            it.expects(true).toBeA(Boolean);
            it.expects(9).toBeA(Number);
            it.expects(9).not.toBeA(String);
            it.expects('').toBeA(String);
            it.expects([]).toBeA(Vector);
            it.expects({}).toBeA(Dictionary);
            it.expects(function(){}).toBeA(Function);
            it.expects(it).toBeA(Thing);
            it.expects(it).toBeA(Object);
        }
    }
}
