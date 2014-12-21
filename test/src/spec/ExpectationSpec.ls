package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    public static class ExpectationSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('Expectations');

            it.should('be executable', function() {
                var f:Function = function(a:Number,b:Number):Number { return a*b; };
                it.expects(f(5,7)).toEqual(5*7);
            });

            it.should('provide boolean matchers', function() {
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
            });

            it.should('provide a negation helper', function() {
                it.expects(false).not.toBeTruthy();
                it.expects(true).not.toBeFalsey();
                it.expects(false).not.not.toBeFalsey();
                it.expects(true).not.not.toBeTruthy();
            });

            it.should('provide an equality matcher', function() {
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
            });

            it.should('provide inequality matchers', function() {
                it.expects(3).toBeLessThan(5);
                it.expects(3).not.toBeLessThan(0);
                it.expects(3).toBeGreaterThan(-5);
                it.expects(3).not.toBeGreaterThan(3);
            });

            it.should('provide a range matcher', function() {
                it.expects(-3).toBePlusOrMinus(5).from(0);
                it.expects(3).not.toBePlusOrMinus(2).from(0);
            });

            it.should('provide a null matcher', function() {
                it.expects(null).toBeNull();
                it.expects(0).not.toBeNull();
                it.expects('').not.toBeNull();
                it.expects(NaN).not.toBeNull();
            });

            it.should('provide an empty matcher', function() {
                it.expects([]).toBeEmpty();
                it.expects('').toBeEmpty();
                it.expects([1,2,3]).not.toBeEmpty();
                it.expects('abc').not.toBeEmpty();
            });

            it.should('provide a membership matcher', function() {
                var v:Vector.<String> = ['a', 'b', 'c'];
                it.expects(v).toContain('b');
                it.expects(v).not.toContain('q');

                var s:String = 'abc';
                it.expects(s).toContain('b');
                it.expects(s).not.toContain('q');

                s = 'the quick brown fox';
                it.expects(s).toContain('brown');
                it.expects(s).not.toContain('dog');
            });

            it.should('provide a type matcher', function() {
                it.expects(true).toBeA(Boolean);
                it.expects(9).toBeA(Number);
                it.expects(9).not.toBeA(String);
                it.expects('').toBeA(String);
                it.expects([]).toBeA(Vector);
                it.expects({}).toBeA(Dictionary);
                it.expects(function(){}).toBeA(Function);
                it.expects(it).toBeA(Thing);
                it.expects(it).toBeA(Object);
            });
        }
    }
}
