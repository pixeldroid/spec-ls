
package pixeldroid.bdd
{
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.Thing;
	import pixeldroid.bdd.models.Randomizer;
	import pixeldroid.bdd.models.ReporterManager;

	public class Spec
	{
		public static const version:String = '1.0.0';

		private static var things:Vector.<Thing> = [];
		private static var reporters:ReporterManager = new ReporterManager();

		public static function describe(thingName:String):Thing
		{
			var thing:Thing = new Thing(thingName);
			things.push(thing);

			return thing;
		}

		public static function addReporter(reporter:Reporter):void
		{
			reporters.add(reporter);
		}

		public static function execute():void
		{
			trace('');
			trace('[Spec v' +version +'] execute()');

			Randomizer.initialize();
			Randomizer.shuffle(things);

			var i:Number;
			var n:Number = things.length;
			for(i = 0; i < n; i++)
			{
				things[i].execute(reporters);
			}
		}

	}
}