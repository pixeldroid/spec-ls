
package pixeldroid.bdd.models
{
    /**
    Encapsulates basic meta data for a specifier.
    */
    public class SpecInfo
    {
        /** Name of the specifier */
        public var name:String;

        /** Release version of the specifier code library */
        public var version:String;

        /** Value to seed the pseudo-random number generator that defines test order */
        public var seed:Number;


        /**
        Create a new SpecInfo instance.

        @param name Name of the specifier library
        @param version Semantic version of the specifier library
        @param seed Value to initialize the pseudo-random number generator that defines test order. Providing the same seed for two different executions will result in the same test order for each execution.
        */
        public function SpecInfo(name:String='Spec', version:String='0.0.0', seed:Number=0)
        {
            this.name = name;
            this.version = version;
            this.seed = seed;
        }

        /**
        Generate a human-readable string describing the instance.

        Result will be in the following format: `[<name> v<version>] seed: <seed>`
        */
        public function toString():String
        {
            return '[' +name +' v' +version +'] seed: ' +seed;
        }
    }
}
