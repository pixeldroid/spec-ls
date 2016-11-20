package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    public static class SpecSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('Spec');

            it.should('be versioned', function() {
                it.expects(Spec.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
            });

            it.should('help declare expectations', function() {
                it.expects('this').not.toEqual('that');
            });
        }
    }
}
