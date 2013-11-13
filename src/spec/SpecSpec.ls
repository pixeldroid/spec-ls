package
{    
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

	public static class SpecSpec
	{
		public static function describe():void
		{
            var it:Thing = Spec.describe('spec-loom');

            it.should('help declare expectations', function() {
                it.expects('this').not.toEqual('that');
            });
		}
	}
}
