
package pixeldroid.random
{
	import system.platform.Platform;


	public final class Randomizer
	{
		public static function initialize(seed:Number=-1):Number
		{
			if (seed < 0)
			{
				// spin the random number generator an unpredictable number of times
				// otherwise, the PRNG always starts from the same default seed
				seed = Platform.getEpochTime() % 100;
			}

			var i:Number = seed;
			while (i--) Math.random();

			return seed;
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