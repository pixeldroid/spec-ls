
package pixeldroid.bdd.models
{
    public class MatchResult
    {
        private var _source:String;
        private var _line:Number;

        public var description:String = '';
        public var success:Boolean = true;
        public var message:String = '';

        public function MatchResult(source:String = null, line:Number = -1)
        {
            _source = source;
            _line = line;
        }


        public function get source():String { return _source; }

        public function get line():Number { return _line; }

        public function hasMessage():Boolean
        {
            return (message && (message.length > 0));
        }
    }
}
