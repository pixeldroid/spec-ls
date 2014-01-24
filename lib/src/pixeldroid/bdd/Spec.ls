
package pixeldroid.bdd
{
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.Thing;
	import pixeldroid.bdd.models.ReporterManager;
	import pixeldroid.random.Randomizer;

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

		public static function execute(seed:Number=-1):void
		{
			seed = Randomizer.initialize(seed);
			Randomizer.shuffle(things);

			// TODO: move out to value object and provide to reporters
			trace('');
			trace('[Spec v' +version +'] seed: ' +seed);

			var i:Number;
			var n:Number = things.length;
			for(i = 0; i < n; i++)
			{
				things[i].execute(reporters);
			}
		}

	}
}