
package pixeldroid.bdd
{
	import pixeldroid.bdd.Matcher;
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.Thing;

	public class Spec
	{
		public static const version:String = '1.0.0';

		private static var things:Vector.<Thing> = [];
		private static var reporters:Vector.<Reporter> = [];

		public static function describe(thingName:String):Thing
		{
			var thing:Thing = new Thing(thingName);
			things.push(thing);

			return thing;
		}

		public static function addReporter(reporter:Reporter):void
		{
			// TODO: make a dictionary to avoid dupes?
			reporters.push(reporter);
		}

		public static function execute():void
		{
			trace('[Spec v' +version +'] execute()');

			var i:Number;
			var n:Number = things.length;
			for(i = 0; i < n; i++)
			{
				things[i].execute(reporters);
			}
		}

	}
}