
package pixeldroid.bdd.models
{
    import pixeldroid.bdd.models.MatchResult;

    import system.CallStackInfo;


    /**
    Represents the description and validation of a requirement; collects results from the validation execution.

    Requirements are created by calling the `should()` method of an instance of `Thing`.
    The validation of the requirement must contain calls to the `expects()` and `asserts()` methods of the same `Thing`.

    @see pixeldroid.bdd.Thing#should
    @see pixeldroid.bdd.Thing#asserts
    @see pixeldroid.bdd.Thing#expects
    */
    public class Requirement
    {
        private var _description:String;
        private var validation:Function;
        private var results:Vector.<MatchResult>;

        public var currentCallInfo:CallStackInfo;


        /**
        Create an requirement from a description and validation function.

        _Opinion:_ Descriptions should begin with a present tense modal verb that completes the
        sentence fragment: "It should ____". Do not include 'should' in the description,
        since the invocation method is called `should()`.

        Example:

        ```as3
        it.should('describe the expected behavior', describe_behavior);
        it.should('start with a modal verb', start_with_verb);
        it.should('be singular in focus', easy_to_test);
        ```

        @param description A phrase describing desired behavior that completes the sentence fragment: "It should ____"
        @param validation A function that tests whether the desired behavior is exhibited
        */
        public function Requirement(description:String, validation:Function)
        {
            _description = description;
            this.validation = validation;
            results = [];
        }


        /**
        Run the validation.

        This will cause results to be added.
        */
        public function test():void
        {
            validation();
        }

        /**
        Add the result of an expectation tested during execution of the validation.

        @param result A `MatchResult` instance generated during the execution of an expectation test chain.
        */
        public function addResult(result:MatchResult):void
        {
            results.push(result);
        }

        /**
        Retrieve the `i`th result.

        @param i Index of the result to retrieve. Valid range is [0, numResults-1].
        */
        public function getResult(i:Number):MatchResult
        {
            return results[i];
        }

        /**
        Query the number of results currently added to the expectation.

        Results are added when the `test()` method is called.
        */
        public function get numResults():Number
        {
            return results.length;
        }

        /**
        Retrieve the description provided for this expectation.

        A phrase that completes the sentence fragment: "It should ____".
        */
        public function get description():String
        {
            return _description;
        }
    }
}
