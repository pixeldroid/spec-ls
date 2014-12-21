
package pixeldroid.random
{
    import system.platform.Platform;

    // TODO: when sprint32 is deprecated, we can remove this class; sprint33 introduced:
    //       * seedable PRNG: system.Random::setSeed, system.Random::randRangeInt
    //       * system.Vector::shuffle

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
            var n:Number = v.length - 1;
            var i:Number;
            var t:Object;

            while (n > 0)
            {
                i = Math.randomRangeInt(0, n);

                t = v[n];
                v[n] = v[i];
                v[i] = t;

                n -= 1;
            }
        }
    }
}
