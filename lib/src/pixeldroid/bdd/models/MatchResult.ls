
package pixeldroid.bdd.models
{
    /**
    Enscapsulates the components of an expectation comparison result.
    */
    public class MatchResult
    {
        private var _source:String;
        private var _line:Number;

        /** Human readable description of the expectation */
        public var description:String = '';

        /** `true` when comparison succeeded, `false` for failure */
        public var success:Boolean = true;

        /** Error message from the match comparison, if any. */
        public var message:String = '';


        /*
        Construct a new MatchResult, noting source file and line number of originating expectation.

        @param source Path to source file containing expectation declaration
        @param line Line number of expectation declaration in source file
        */
        public function MatchResult(source:String = null, line:Number = -1)
        {
            _source = source;
            _line = line;
        }


        /* Path to source file containing expectation declaration */
        public function get source():String { return _source; }

        /* Line number of expectation declaration in source file */
        public function get line():Number { return _line; }

        /**
        Query for the presence of an error message.

        `true` when the result has an error message, `false` when no non-empty message exists.
        */
        public function hasMessage():Boolean
        {
            return (message && (message.length > 0));
        }
    }
}
