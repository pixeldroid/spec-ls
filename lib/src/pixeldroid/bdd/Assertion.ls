
package pixeldroid.bdd
{
    import system.CallStackInfo;
    import system.Debug;
    import system.Process;
    import system.reflection.Type;

    import pixeldroid.bdd.Matcher;
    import pixeldroid.bdd.models.Requirement;


    public class Assertion
    {
        private var value1:Object;
        private var source:String;
        private var line:Number;

        public static const defaultAsserter:Asserter = new ExitAsserter();
        public static var asserter:Asserter = defaultAsserter;


        public function Assertion(context:Requirement, value:Object)
        {
            value1 = value;

            var callStack:Vector.<CallStackInfo> = Debug.getCallStack();
            var stackFrame:Number;
            var csi:CallStackInfo;

            for (stackFrame = callStack.length - 1; stackFrame >= 0; stackFrame--)
            {
                csi = callStack[stackFrame];
                if (Matcher.stringEndsWith(csi.source, context.getTypeName() +'.ls'))
                {
                    stackFrame--;
                    csi = callStack[stackFrame];
                    source = csi.source;
                    line = csi.line;
                    break;
                }
            }
        }

        protected function getAsserter(condition:Boolean):Asserter
        {
            var a:Asserter = asserter.getType().getConstructor().invoke() as Asserter;
            a.init(condition, source, line);

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

            if (isTypeMatch(value1, String))
            {
                var s:String = value1 as String;
                condition = (s.length == 0);
            }
            else if (isTypeMatch(value1, Vector))
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

            if (isTypeMatch(value1, String))
            {
                var s:String = value1 as String;
                condition = (s.length > 0);
            }
            else if (isTypeMatch(value1, Vector))
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
            var condition:Boolean = (isTypeMatch(value1, type) || isSubtypeMatch(value1, type));
            return getAsserter(condition);
        }


        // helpers
        private function isTypeMatch(value:Object, type:Type):Boolean
        {
            return (value.getFullTypeName() == type.getFullName());
        }

        private function isSubtypeMatch(value:Object, type:Type):Boolean
        {
            return ((value instanceof type) || (value is type) || ((value as type) != null));
        }

    }


    public interface Asserter
    {
        function init(condition:Boolean, source:String, line:Number):void;
        function or(message:String):Boolean;
    }

    public class ExitAsserter implements Asserter
    {
        private static const FAILURE:Number = 1;

        private var condition:Boolean;
        private var source:String;
        private var line:Number;

        public function init(condition:Boolean, source:String, line:Number):void
        {
            this.condition = condition;
            this.source = source;
            this.line = line;
        }

        public function or(message:String):Boolean
        {
            if (!condition)
            {
                trace('runtime assertion failed:', message);
                trace(source +':' +line);

                Process.exit(FAILURE);
            }

            return true;
        }
    }
}
