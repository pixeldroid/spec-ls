
package pixeldroid.bdd
{
    import pixeldroid.bdd.Matcher;
    import pixeldroid.bdd.ThingValidator;
    import pixeldroid.bdd.models.Expectation;


    public class Thing
    {
        private var _name:String = '<thing>';
        private var validator:ThingValidator;
        private const expectations:Vector.<Expectation> = [];


        public function Thing(name:String)
        {
            _name = name;
        }

        public function get name():String { return _name; }

        public function should(declaration:String, validation:Function):void
        {
            Debug.assert(validation, 'validation function must not be null');
            expectations.push(new Expectation(declaration, validation));
        }

        public function submitForValidation(validator:ThingValidator):void
        {
            this.validator = validator;
            this.validator.setExpectations(expectations);
        }

        public function expects(value:Object):Matcher
        {
            Debug.assert(validator, 'validator must be initialized via submitForValidation');
            return validator.getMatcher(value);
        }
    }
}
