
package pixeldroid.bdd
{
	import pixeldroid.bdd.Thing;
	import pixeldroid.bdd.Matcher;
	import pixeldroid.bdd.models.MatchResult;

	public class Matcher
	{
		// positive matchers do what they say, negative matchers do the opposite
		private var positive:Boolean = true;
		
		private var context:Thing;
		private var result:MatchResult;
		private var value:Object;


		public function Matcher(context:Thing, value:Object)
		{
			this.context = context;
			this.value = value;
			result = new MatchResult();
		}


		public function get not():Matcher
		{
			positive = !positive;
			return this;
		}


		public function toBeA(type:Object):void
		{
			result.success = getAdjustedMatch( ((value as type) is type) );
			result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toBeA '" +type.toString() +"'";

			context.addResult(result);
		}

		public function toBeNaN():void
		{
			result.success = getAdjustedMatch( (isNaN(value as Number)) );
			result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toBeNaN";

			context.addResult(result);
		}

		public function toBeNull():void
		{
			result.success = getAdjustedMatch( (value == null) );
			result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toBeNull";

			context.addResult(result);
		}

		public function toBeTruthy():void
		{
			var match:Boolean = isNaN(value as Number) ? false : !!(value);
			result.success = getAdjustedMatch( match );
			result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toBeTruthy";

			context.addResult(result);
		}

		public function toBeFalsey():void
		{
			var match:Boolean = isNaN(value as Number) ? true : !!!(value);
			result.success = getAdjustedMatch( match );
			result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toBeFalsey";

			context.addResult(result);
		}

		public function toBeLessThan(value2:Number):void
		{
			result.success = getAdjustedMatch( (value < value2) );
			result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toBeLessThan '" +value2.toString() +"'";

			context.addResult(result);
		}

		public function toBeGreaterThan(value2:Number):void
		{
			result.success = getAdjustedMatch( (value > value2) );
			result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toBeGreaterThan '" +value2.toString() +"'";

			context.addResult(result);
		}

		public function toContain(value2:Object):void
		{
			// in LoomScript, Vector is the only list data type
            var vector:Vector = [];
            var isVector:Boolean = (value.getFullTypeName() == vector.getFullTypeName());

            if (isVector)
            {
            	vector = value as Vector;
				result.success = getAdjustedMatch( (vector.contains(value2)) );
				result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toContain '" +value2.toString() +"'";
            }
            else
            {
				result.success = false;
				result.message = "a Vector to test with, but '" +value.toString() +"' is not a Vector";
            }

			context.addResult(result);
		}

		public function toEqual(value2:Object):void
		{
			result.success = getAdjustedMatch( (value == value2) );
			result.message = "'" +value.toString() +"'" +(positive ? "" : " not") +" toEqual '" +value2.toString() +"'";

			context.addResult(result);
		}


		private function getAdjustedMatch(condition:Boolean):Boolean
		{
			return positive ? (condition) : !(condition);
		}

	}
}