
package pixeldroid.bdd.models
{

    /**
    Enscapsulates the components of an expectation comparison result.
    */
    public class MatchResult
    {
        /** Path to source file containing expectation declaration */
        public var source:String = null;

        /** Line number of expectation declaration in source file */
        public var line:Number = -1;

        /** Method name of expectation declaration in source file */
        public var method:String = null;

        /** Human readable description of the expectation */
        public var description:String = '';

        /** `true` when comparison succeeded, `false` for failure */
        public var success:Boolean = true;

        /** Error message from the match comparison, if any. */
        public var message:String = '';

        /**
        Query for the presence of an error message.

        `true` when the result has an error message, `false` when no non-empty message exists.
        */
        public function hasMessage():Boolean
        {
            return (message && (message.length > 0));
        }

        /**
        Retrieve a formatted call trace showing source, method and line number of the validation call that generated this result.

        e.g. `./src/spec//AssertionSpec.ls(provide_type_assertion):89`
        */
        public function get callTrace():String
        {
            return (source +'(' +method +'):' +line);
        }
    }
}
