
package pixeldroid.bdd
{
    import system.Debug;
    import system.Process;
    import system.reflection.Type;

    import pixeldroid.bdd.Does;
    import pixeldroid.bdd.models.Requirement;
    import pixeldroid.platform.CallUtil;


    public class Assertion
    {
        private var value1:Object;
        private var source:String;
        private var line:Number;
        private var method:String;

        public static const defaultAsserter:Asserter = new ExitAsserter();
        public static var asserter:Asserter = defaultAsserter;


        public function Assertion(context:Requirement, value:Object)
        {
            value1 = value;
            source = context.currentCallInfo.source;
            line = context.currentCallInfo.line;
            method = context.currentCallInfo.method.getName();
        }

        protected function getAsserter(condition:Boolean):Asserter
        {
            var a:Asserter = asserter.getType().getConstructor().invoke() as Asserter;
            a.init(condition, source, line, method);

            return a;
        }


        public function isNotNaN():Asserter
        {
            var condition:Boolean = (!isNaN(value1 as Number));
            return getAsserter(condition);
        }

        public function isNull():Asserter
        {
            var condition:Boolean = (value1 == null);
            return getAsserter(condition);
        }

        public function isNotNull():Asserter
        {
            var condition:Boolean = (value1 != null);
            return getAsserter(condition);
        }

        public function isEmpty():Asserter
        {
            var condition:Boolean;

            if (Does.typeMatch(value1, String))
            {
                var s:String = value1 as String;
                condition = (s.length == 0);
            }
            else if (Does.typeMatch(value1, Vector))
            {
                var vector:Vector = value1 as Vector;
                condition = (vector.length == 0);
            }
            else
            {
                (getAsserter(false)).or('value provided is not a container');
            }

            return getAsserter(condition);
        }

        public function isNotEmpty():Asserter
        {
            var condition:Boolean;

            if (Does.typeMatch(value1, String))
            {
                var s:String = value1 as String;
                condition = (s.length > 0);
            }
            else if (Does.typeMatch(value1, Vector))
            {
                var vector:Vector = value1 as Vector;
                condition = (vector.length > 0);
            }
            else
            {
                (getAsserter(false)).or('value provided is not a container');
            }

            return getAsserter(condition);
        }

        public function isEqualTo(value2:Object):Asserter
        {
            var condition:Boolean = (value1 == value2);
            return getAsserter(condition);
        }

        public function isNotEqualTo(value2:Object):Asserter
        {
            var condition:Boolean = (value1 != value2);
            return getAsserter(condition);
        }

        public function isGreaterThan(value2:Number):Asserter
        {
            var condition:Boolean = (value1 > value2);
            return getAsserter(condition);
        }

        public function isLessThan(value2:Number):Asserter
        {
            var condition:Boolean = (value1 < value2);
            return getAsserter(condition);
        }

        public function isTypeOf(type:Type):Asserter
        {
            var condition:Boolean = (Does.typeMatch(value1, type) || Does.subtypeMatch(value1, type));
            return getAsserter(condition);
        }


    }


    public interface Asserter
    {
        function init(condition:Boolean, source:String, line:Number, method:String):void;
        function or(message:String):Boolean;
    }

    public class ExitAsserter implements Asserter
    {
        private static const FAILURE:Number = 1;

        private var condition:Boolean;
        private var source:String;
        private var line:Number;
        private var method:String;

        public function init(condition:Boolean, source:String, line:Number, method:String):void
        {
            this.condition = condition;
            this.source = source;
            this.line = line;
            this.method = method;
        }

        public function or(message:String):Boolean
        {
            if (!condition)
            {
                trace('runtime assertion failed:', message);
                trace(source +'(' +method +'):' +line);

                Process.exit(FAILURE);
            }

            return true;
        }
    }
}
