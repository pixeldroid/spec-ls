
package pixeldroid.bdd.models
{
	import system.platform.Platform;


	public final class Randomizer
	{
		public static function initialize():void
		{
			// spin the random number generator an unpredictable number of times
			// otherwise, the PRNG always starts from the same default seed
			var n:Number = Platform.getEpochTime() % 100;
			while (n-- > 0) Math.random();
		}

		public static function shuffle(v:Vector.<Object>):void
		{
			// Fisher-Yates
			var n:Number = v.length;
			var i:Number;
			var t:Object;

			while (n > 0)
			{
				i = Math.floor(Math.random() * n);
				n -= 1;

				t = v[n];
				v[n] = v[i];
				v[i] = t;
			}
		}
	}
}