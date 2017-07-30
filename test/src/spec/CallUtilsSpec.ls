package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;
    import pixeldroid.platform.CallUtils;

    import system.CallStackInfo;
    import system.Debug;


    public static class CallUtilsSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('CallUtils');

            it.should('find a stack frame by method name', find_by_name);
            it.should('retrieve a stack frame by relative distance', fetch_by_distance);
            it.should('handle out of range requests for a stack frame by returning null', null_when_range_invalid);
            it.should('prepare a loggable string from a single stack frame', make_loggable_frame);
            it.should('prepare a vector of loggable strings from a full stack trace', make_loggable_stack);
        }


        private static function find_by_name():void
        {
            var callingFrame:CallStackInfo = CallUtils.findCallingStackFrame('find_by_name');

            it.expects(callingFrame.source).toEndWith('pixeldroid/bdd/models/Requirement.ls');
            it.expects(callingFrame.method.getName()).toEqual('test');

            callingFrame = CallUtils.findCallingStackFrame('no_such_method');
            it.expects(callingFrame).toBeNull();
        }

        private static function fetch_by_distance():void
        {
            var callingFrame:CallStackInfo = CallUtils.getPriorStackFrame(0);

            it.expects(callingFrame.method.getName()).toEqual('fetch_by_distance');
        }

        private static function null_when_range_invalid():void
        {
            var stack:Vector.<CallStackInfo> = Debug.getCallStack();
            var under:Number = -2;
            var over:Number = stack.length;

            it.expects(CallUtils.getPriorStackFrame(under)).toBeNull();
            it.expects(CallUtils.getPriorStackFrame(over)).toBeNull();
        }

        private static function make_loggable_frame():void
        {
            var callingFrame:CallStackInfo = CallUtils.getPriorStackFrame(0);

            it.expects(CallUtils.toCallTrace(callingFrame)).toEqual('./src/spec//CallUtilsSpec.ls(make_loggable_frame):57');
        }

        private static function make_loggable_stack():void
        {
            var loggableStack:Vector.<String> = CallUtils.traceCallStack();

            it.asserts(loggableStack.length).isGreaterThan(1);
            loggableStack.pop(); // get rid of the call to traceCallStack()
            it.expects(loggableStack.pop()).toEqual('./src/spec//CallUtilsSpec.ls(make_loggable_stack):64');
        }
    }
}
