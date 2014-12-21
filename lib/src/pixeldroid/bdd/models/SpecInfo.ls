
package pixeldroid.bdd.models
{
    public class SpecInfo
    {
        public var name:String;
        public var version:String;
        public var seed:Number;


        public function SpecInfo(name:String='Spec', version:String='0.0.0', seed:Number=0)
        {
            this.name = name;
            this.version = version;
            this.seed = seed;
        }

        public function toString():String
        {
            return '[' +name +' v' +version +'] seed: ' +seed;
        }
    }
}
