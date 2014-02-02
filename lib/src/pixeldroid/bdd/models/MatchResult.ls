
package pixeldroid.bdd.models
{
	public class MatchResult
	{
		public var description:String = '';
		public var success:Boolean = true;
		public var message:String = '';

		public function hasMessage():Boolean
		{
			return (message && (message.length > 0));
		}
	}
}