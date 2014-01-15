
package pixeldroid.bdd.models
{
	import pixeldroid.bdd.models.MatchResult;

	public class Expectation
	{
		public var description:String;
		private var validation:Function;
		private var results:Vector.<MatchResult>;


		public function Expectation(description:String, validation:Function)
		{
			this.description = description;
			this.validation = validation;
			results = [];
		}


		public function test():void
		{
			validation();
		}

		public function addResult(result:MatchResult):void
		{
			results.push(result);
		}

		public function getResult(i:Number):MatchResult
		{
			return results[i];
		}

		public function get numResults():Number
		{
			return results.length;
		}
	}
}