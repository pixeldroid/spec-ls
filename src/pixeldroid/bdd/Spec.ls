
package pixeldroid.bdd
{
	import pixeldroid.bdd.Matcher;
	import pixeldroid.bdd.Thing;

	public class Spec
	{
		private static var things:Vector.<Thing> = [];

		public static function describe(thingName:String):Thing
		{
			var thing:Thing = new Thing(thingName);
			things.push(thing);

			return thing;
		}

		public static function execute():void
		{
			trace('[Spec] execute()');

			var i:Number;
			var n:Number = things.length;
			for(i = 0; i < n; i++)
			{
				things[i].execute();
				things[i].printExecutionLog();
			}
		}

	}
}