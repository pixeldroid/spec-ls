
package pixeldroid.bdd
{
	import pixeldroid.bdd.Thing;
	import pixeldroid.bdd.models.MatchResult;

	public class Matcher
	{
		private var positive:Boolean = true;
		private var absoluteDelta:Number = 0;

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

		public function toBePlusOrMinus(absoluteDelta:Number):Matcher
		{
			this.absoluteDelta = absoluteDelta;
			return this;
		}


		// matchers
		public function toBeA(type:Type):void
		{
			var match:Boolean = (isTypeMatch(value, type) || isSubtypeMatch(value, type));

			result.success = rectifiedMatch( match );
			result.description = "'" +value.getFullTypeName() +"' " +rectifiedPrefix("toBeA") +" '" +type.getFullName() +"'";

			if (!result.success) result.message = "types " +rectifiedSuffix("do", true) +" match.";

			context.addResult(result);
		}

		public function toBeNaN():void
		{
			result.success = rectifiedMatch( (isNaN(value as Number)) );
			result.description = "'" +value.toString() +"' " +rectifiedPrefix("toBeNaN");

			if (!result.success) result.message = "value " +rectifiedSuffix("is", true) +" not-a-number.";

			context.addResult(result);
		}

		public function toBeNull():void
		{
			result.success = rectifiedMatch( (value == null) );
			result.description = "'" +value.toString() +"' " +rectifiedPrefix("toBeNull");

			if (!result.success) result.message = "value " +rectifiedSuffix("is", true) +" null.";

			context.addResult(result);
		}

		public function toBeTruthy():void
		{
			var match:Boolean = isNaN(value as Number) ? false : !!(value);
			result.success = rectifiedMatch( match );
			result.description = "'" +value.toString() +"' " +rectifiedPrefix("toBeTruthy");

			if (!result.success) result.message = "value " +rectifiedSuffix("is", true) +" truthy.";

			context.addResult(result);
		}

		public function toBeFalsey():void
		{
			var match:Boolean = isNaN(value as Number) ? true : !!!(value);
			result.success = rectifiedMatch( match );
			result.description = "'" +value.toString() +"' " +rectifiedPrefix("toBeFalsey");

			if (!result.success) result.message = "value " +rectifiedSuffix("is", true) +" falsey.";

			context.addResult(result);
		}

		public function toBeLessThan(value2:Number):void
		{
			result.success = rectifiedMatch( (value < value2) );
			result.description = value.toString() +" " +rectifiedPrefix("toBeLessThan") +" " +value2.toString();

			if (!result.success) result.message = "value " +rectifiedSuffix("is", true) +" less than " +value2.toString() +".";

			context.addResult(result);
		}

		public function toBeGreaterThan(value2:Number):void
		{
			result.success = rectifiedMatch( (value > value2) );
			result.description = value.toString() +" " +rectifiedPrefix("toBeGreaterThan") +" " +value2.toString();

			if (!result.success) result.message = "value " +rectifiedSuffix("is", true) +" greater than " +value2.toString() +".";

			context.addResult(result);
		}

		public function toBeEmpty():void
		{
			if (isTypeMatch(value, String))
			{
				var s:String = value as String;
				result.success = rectifiedMatch( (s.length == 0) );
				result.description = "'" +value.toString() +"' " +rectifiedPrefix("toBeEmpty");

				if (!result.success) result.message = "String " +rectifiedSuffix("is", true) +" empty.";
			}
			else if (isTypeMatch(value, Vector))
			{
				var vector:Vector = value as Vector;
				result.success = rectifiedMatch( (vector.length == 0) );
				result.description = "[" +value.toString() +"] " +rectifiedPrefix("toBeEmpty");

				if (!result.success) result.message = "Vector " +rectifiedSuffix("is", true) +" empty.";
			}
			else
			{
				notAContainer(value, result);
			}

			context.addResult(result);
		}

		public function toContain(value2:Object):void
		{
			if (isTypeMatch(value, String))
			{
				var string1:String = value as String;
				var string2:String = value2 as String;
				result.success = rectifiedMatch( (string1.indexOf(string2) > -1) );
				result.description = "'" +string1 +"' " +rectifiedPrefix("toContain") +" '" +string2 +"'";

				if (!result.success) result.message = "String " +rectifiedSuffix("does", true) +" contain '" +string2 +"'.";
			}
			else if (isTypeMatch(value, Vector))
			{
				var vector:Vector = value as Vector;
				result.success = rectifiedMatch( (vector.contains(value2)) );
				result.description = "[" +value.toString() +"] " +rectifiedPrefix("toContain") +" '" +value2.toString() +"'";

				if (!result.success) result.message = "Vector " +rectifiedSuffix("does", true) +" contain '" +value2.toString() +"'.";
			}
			else
			{
				notAContainer(value, result);
			}

			context.addResult(result);
		}

		public function toEqual(value2:Object):void
		{
			result.success = rectifiedMatch( (value == value2) );
			result.description = "'" +value.toString() +"' " +rectifiedPrefix("toEqual") +" '" +value2.toString() +"'";

			if (!result.success) result.message = "values " +rectifiedSuffix("are", true) +" equal.";

			context.addResult(result);
		}

		public function from(value2:Number):void
		{
			result.success = rectifiedMatch( (Math.abs(value2 - value) <= absoluteDelta) );
			result.description = value.toString() +" " +rectifiedPrefix("toBePlusOrMinus") +" " +absoluteDelta.toString() +" from " +value2.toString();
			result.message = value.toString() +" is " +Math.abs(value2 - value) +" away from " +value2.toString();

			context.addResult(result);
		}


		// helpers
		private function isTypeMatch(value:Object, type:Type):Boolean
		{
			return (value.getFullTypeName() == type.getFullName());
		}

		private function isSubtypeMatch(value:Object, type:Type):Boolean
		{
			return ((value instanceof type) || (value is type) || ((value as type) != null));
		}

		private function rectifiedSuffix(phrase:String, flipped:Boolean = false):String
		{
			if (flipped) return (!positive ? phrase : phrase +' not');
			return (positive ? phrase : phrase +' not');
		}

		private function rectifiedPrefix(phrase:String, flipped:Boolean = false):String
		{
			if (flipped) return (!positive ? phrase : 'not ' +phrase);
			return (positive ? phrase : 'not ' +phrase);
		}

		private function rectifiedMatch(condition:Boolean):Boolean
		{
			return positive ? (condition) : !(condition);
		}

		private function notAContainer(value:Object, result:MatchResult):void
		{
			result.success = false;
			result.description = "a container type";
			result.message = "'" +value.toString() +"' is not a String or Vector type value";
		}

	}
}
