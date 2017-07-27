
package pixeldroid.bdd
{
    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.SpecInfo;

    /**
    Documents the results of executing a specification.
    */
    public interface Reporter
    {
        /**
        Initialize the reporting session with information about the specification framework.

        Called once before any validation begins.

        @param specInfo Metadata about the specification framework
        */
        function init(specInfo:SpecInfo):void;

        /**
        Start the reporting session for a single specification.

        Called once per spec when testing begins, to provide the name of the test subject and
        the total number of expectations to be validated.

        @param name Subject of the test; the thing being described
        @param total Number of expectations to be tested
        */
        function begin(name:String, total:Number):void;

        /**
        Record the results of one expectation.

        Called once per each expectation to be tested.

        @param expectation The expectation tested. Provides access to the `MatchResult`
        @param durationSec Seconds elapsed during the execution of this expectation. Floating point value.
        @param index Zero-based index of the expectation being reported. Range is [0, total-1]
        @param total Number of expectations to be tested
        */
        function report(expectation:Expectation, durationSec:Number, index:Number, total:Number):void;

        /**
        Complete the reporting session for a single specification.

        Called once per spec after all expectations have been validated.

        @param name Subject of the test; the thing being described
        @param durationSec Total length of the spec validation, in seconds. Floating point value.
        */
        function end(name:String, durationSec:Number):Boolean;

        /**
        Finalize the reporting session altogether.

        Called once after all expectations of all specifications have been validated.

        @param durationSec Total length of the full test of all specifications provided, in seconds. Floating point value.
        */
        function finalize(durationSec:Number):void;
    }
}
