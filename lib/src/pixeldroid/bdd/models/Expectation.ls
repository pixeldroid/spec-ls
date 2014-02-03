
package pixeldroid.bdd.models
{
	import pixeldroid.bdd.models.MatchResult;

	public class Expectation
	{
		private var _description:String;
		private var validation:Function;
		private var results:Vector.<MatchResult>;


		public function Expectation(description:String, validation:Function)
		{
			_description = description;
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

		public function get description():String
		{
			return _description;
		}
	}
}