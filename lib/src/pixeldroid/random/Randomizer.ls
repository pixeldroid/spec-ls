
package pixeldroid.random
{
    import system.Random;
    import system.platform.Platform;

    // TODO: when system.Vector::shuffle uses system.Random::randRangeInt, we can remove this class

    public final class Randomizer
    {
        public static function initialize(seed:Number=-1):Number
        {
            if (seed < 0)
            {
                var t:Number = Platform.getEpochTime();
                Random.setSeed(t % 1000);
                seed = Random.randRangeInt(10000, 99999);
            }

            Random.setSeed(seed);

            return seed;
        }

        public static function shuffle(v:Vector.<Object>):void
        {
            // Fisher-Yates
            var n:Number = v.length - 1;
            var i:Number;
            var t:Object;

            while (n > 0)
            {
                i = Random.randRangeInt(0, n);

                t = v[n];
                v[n] = v[i];
                v[i] = t;

                n -= 1;
            }
        }
    }
}
