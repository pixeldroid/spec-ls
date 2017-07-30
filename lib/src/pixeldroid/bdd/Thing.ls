
package pixeldroid.bdd
{
    import pixeldroid.bdd.Expectation;
    import pixeldroid.bdd.ThingValidator;
    import pixeldroid.bdd.models.Requirement;
    import pixeldroid.platform.CallUtils;

    import system.CallStackInfo;


    /**
    A test subject whose behavior will be described through requirements.

    Use the `should` method to describe a desired behavior and a function that
    validates the behavior with one or more calls to the `expects` method:

    ```as3
    public static class SampleSpec
    {
        private static const it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('Sample');
            it.should('be enabled by default', initialize_enabled);
        }

        private static function initialize_enabled():void
        {
            var sample:Sample = new TestSample();
            it.expects(sample.enabled).toBeTruthy();
        }
    }
    ```

    An `asserts` method is also provided, with an intended use of
    ensuring expectations have valid data to run, e.g.:

    ```as3
    private static function initialize_with_c_third():void
    {
        var sample:Sample = new TestSample();
        it.asserts(sample.letters.length).isEqualTo(3).or('letters does not contain three items');
        it.expects(sample.letters[2]).toEqual('c');
    }
    ```

    As such, assertions don't test behavior and are not included in the test results.
    */
    public class Thing
    {
        private var _name:String = '<thing>';
        private var validator:ThingValidator;
        private const requirements:Vector.<Requirement> = [];


        /**
        Instantiate a named test subject.

        @param name Name of the test subject (typically its class name)
        */
        public function Thing(name:String)
        {
            _name = name;
        }

        /** Retrieve the name of the test subject. */
        public function get name():String { return _name; }

        /**
        Declare an expectation about the behavior of this test subject.

        Declarations should begin with a present tense modal verb that completes the
        sentence fragment: "It should ____".

        Validations must include at least one call to `expects` to validate the behavior.

        @param declaration Statement that describes valid behavior
        @param validation Function that tests for the desired bahavior, using `expects()`
        */
        public function should(declaration:String, validation:Function):void
        {
            Debug.assert(validation, 'validation function must not be null');
            requirements.push(new Requirement(declaration, validation));
        }

        /**
        provide requirements to a validator for testing.

        @param validator A test execution engine that can process the requirements of this subject's behavior
        */
        public function submitForValidation(validator:ThingValidator):void
        {
            this.validator = validator;
            this.validator.setRequirements(requirements);
        }

        /**
        Ensure a critical condition is true, or else abort application execution and log an error message to the console.

        @param value A value to set an assertion for
        */
        public function asserts(value:Object):Assertion
        {
            Debug.assert(validator, 'validator must be initialized via submitForValidation');
            var csi:CallStackInfo = CallUtils.getPriorStackFrame();
            return validator.getAssertion(value, csi);
        }

        /**
        Start a value matching chain to compare the provided value to the results of one or more `Expectation`.

        @param value A value to set requirements for
        */
        public function expects(value:Object):Expectation
        {
            Debug.assert(validator, 'validator must be initialized via submitForValidation');
            var csi:CallStackInfo = CallUtils.getPriorStackFrame();
            return validator.getExpectation(value, csi);
        }
    }
}
