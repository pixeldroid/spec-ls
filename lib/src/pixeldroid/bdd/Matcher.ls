
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
			result.description = "'" +value.getFullTypeName() +"' " +rectifiedPhrase("toBeA") +" '" +type.getFullName() +"'";

			context.addResult(result);
		}

		public function toBeNaN():void
		{
			result.success = rectifiedMatch( (isNaN(value as Number)) );
			result.description = "'" +value.toString() +"' " +rectifiedPhrase("toBeNaN");

			context.addResult(result);
		}

		public function toBeNull():void
		{
			result.success = rectifiedMatch( (value == null) );
			result.description = "'" +value.toString() +"' " +rectifiedPhrase("toBeNull");

			context.addResult(result);
		}

		public function toBeTruthy():void
		{
			var match:Boolean = isNaN(value as Number) ? false : !!(value);
			result.success = rectifiedMatch( match );
			result.description = "'" +value.toString() +"' " +rectifiedPhrase("toBeTruthy");

			context.addResult(result);
		}

		public function toBeFalsey():void
		{
			var match:Boolean = isNaN(value as Number) ? true : !!!(value);
			result.success = rectifiedMatch( match );
			result.description = "'" +value.toString() +"' " +rectifiedPhrase("toBeFalsey");

			context.addResult(result);
		}

		public function toBeLessThan(value2:Number):void
		{
			result.success = rectifiedMatch( (value < value2) );
			result.description = value.toString() +" " +rectifiedPhrase("toBeLessThan") +" " +value2.toString();

			context.addResult(result);
		}

		public function toBeGreaterThan(value2:Number):void
		{
			result.success = rectifiedMatch( (value > value2) );
			result.description = value.toString() +" " +rectifiedPhrase("toBeGreaterThan") +" " +value2.toString();

			context.addResult(result);
		}

		public function toBeEmpty():void
		{
			if (isTypeMatch(value, String))
			{
				var s:String = value as String;
				result.success = rectifiedMatch( (s.length == 0) );
				result.description = "'" +value.toString() +"' " +rectifiedPhrase("toBeEmpty");
			}
			else if (isTypeMatch(value, Vector))
			{
				var vector:Vector = value as Vector;
				result.success = rectifiedMatch( (vector.length == 0) );
				result.description = "[" +value.toString() +"] " +rectifiedPhrase("toBeEmpty");
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
				result.success = rectifiedMatch( (string1.indexOf(string2, 0) > -1) );
				result.description = "'" +string1 +"' " +rectifiedPhrase("toContain") +" '" +string2 +"'";
			}
			else if (isTypeMatch(value, Vector))
			{
				var vector:Vector = value as Vector;
				result.success = rectifiedMatch( (vector.contains(value2)) );
				result.description = "[" +value.toString() +"] " +rectifiedPhrase("toContain") +" '" +value2.toString() +"'";
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
			result.description = "'" +value.toString() +"' " +rectifiedPhrase("toEqual") +" '" +value2.toString() +"'";

			context.addResult(result);
		}

		public function from(value2:Number):void
		{
			result.success = rectifiedMatch( (Math.abs(value2 - value) <= absoluteDelta) );
			result.description = value.toString() +" " +rectifiedPhrase("toBePlusOrMinus") +" " +absoluteDelta.toString() +" from " +value2.toString();
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
			/*
			FIXME: there is a known bug with is, as, and instanceof operators on Type variables,
			which is preventing inheritance & interface matching from working:

			LOOM-1759 - http://theengine.co/forums/troubleshooting-and-issues/topics/bug-type-ops-only-work-on-literal-values/posts/4445

			// i.e., these fail when invoked against the input variable to this function named type,
			// but would operate correctly if invoked against a literal type like Number, or MyClass:
			var match:Boolean = (value instanceof type);
			var match:Boolean = (value is type);
			var match:Boolean = ((value as type) != null);
			*/
			return ((value instanceof type) || (value is type) || ((value as type) != null));
		}

		private function rectifiedPhrase(phrase:String):String
		{
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