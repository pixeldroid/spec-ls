
package pixeldroid.bdd
{
	import pixeldroid.bdd.Thing;
	import pixeldroid.bdd.Matcher;
	import pixeldroid.bdd.models.MatchResult;

	public class Matcher
	{
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


		// modifiers
		public function get not():Matcher
		{
			positive = !positive;
			return this;
		}



		// matchers
		public function toBeA(type:Type):void
		{
			// FIXME: there is a known bug with type operators on values passed to functions:
			// LOOM-1759 - http://theengine.co/forums/troubleshooting-and-issues/topics/bug-type-ops-only-work-on-literal-values/posts/4445
			var match:Boolean = (value.getFullTypeName() == type.getFullName()) || (value instanceof type) || (value is type);
			//var match:Boolean = (value.getFullTypeName() == type.getFullName());
			//var match:Boolean = (value instanceof type);
			//var match:Boolean = (value is type);
			//var match:Boolean = ((value as type) != null);
			result.success = rectifiedMatch( match );
			result.message = "'" +value.getFullTypeName() +"' " +rectifiedPhrase("toBeA") +" '" +type.getFullName() +"'";

			context.addResult(result);
		}

		public function toBeNaN():void
		{
			result.success = rectifiedMatch( (isNaN(value as Number)) );
			result.message = "'" +value.toString() +"' " +rectifiedPhrase("toBeNaN");

			context.addResult(result);
		}

		public function toBeNull():void
		{
			result.success = rectifiedMatch( (value == null) );
			result.message = "'" +value.toString() +"' " +rectifiedPhrase("toBeNull");

			context.addResult(result);
		}

		public function toBeTruthy():void
		{
			var match:Boolean = isNaN(value as Number) ? false : !!(value);
			result.success = rectifiedMatch( match );
			result.message = "'" +value.toString() +"' " +rectifiedPhrase("toBeTruthy");

			context.addResult(result);
		}

		public function toBeFalsey():void
		{
			var match:Boolean = isNaN(value as Number) ? true : !!!(value);
			result.success = rectifiedMatch( match );
			result.message = "'" +value.toString() +"' " +rectifiedPhrase("toBeFalsey");

			context.addResult(result);
		}

		public function toBeLessThan(value2:Number):void
		{
			result.success = rectifiedMatch( (value < value2) );
			result.message = value.toString() +" " +rectifiedPhrase("toBeLessThan") +" " +value2.toString();

			context.addResult(result);
		}

		public function toBeGreaterThan(value2:Number):void
		{
			result.success = rectifiedMatch( (value > value2) );
			result.message = value.toString() +" " +rectifiedPhrase("toBeGreaterThan") +" " +value2.toString();

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
			result.success = rectifiedMatch( (value == value2) );
			result.message = "'" +value.toString() +"' " +rectifiedPhrase("toEqual") +" '" +value2.toString() +"'";

			context.addResult(result);
		}

			context.addResult(result);
		}


		// helpers
		private function rectifiedPhrase(phrase:String):String
		{
			return (positive ? phrase : 'not ' +phrase);
		}

		private function rectifiedMatch(condition:Boolean):Boolean
		{
			return positive ? (condition) : !(condition);
		}

	}
}