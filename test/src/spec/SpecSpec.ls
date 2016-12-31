package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;


    public static class SpecSpec
    {
        private static const it:Thing = Spec.describe('Spec');

        public static function describe():void
        {
            it.should('be versioned', be_versioned);
            it.should('help declare expectations', declare_expectations);
        }


        private static function be_versioned():void
        {
            it.expects(Spec.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
        }

        private static function declare_expectations():void
        {
            it.expects('this').not.toEqual('that');
        }
    }
}
