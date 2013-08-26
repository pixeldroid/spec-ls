
package pixeldroid.bdd
{
	public class Expectation
	{
		public var description:String;
		private var validation:Function;

		public function Expectation(description:String, validation:Function)
		{
			this.description = description;
			this.validation = validation;
		}

		public function test():void
		{
			validation();
		}
	}
}