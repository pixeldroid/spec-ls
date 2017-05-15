package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;


    public static class SpecSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('Spec');

            it.should('be versioned', be_versioned);
            it.should('help declare expectations', declare_expectations);
        }


        private static function be_versioned():void
        {
            it.expects(Spec.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
        }

        private static function declare_expectations():void
        {
            it.expects('this').not.toEqual('that other thing');
        }
    }
}
