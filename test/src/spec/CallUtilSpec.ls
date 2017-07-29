package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;
    import pixeldroid.platform.CallUtil;


    public static class CallUtilSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('CallUtil');

            it.should('find a stack frame by method name', find_by_name);
            it.should('retrieve a stack frame by relative distance', fetch_by_distance);
            it.should('prepare a loggable string from a single stack frame', make_loggable_frame);
            it.should('prepare a vector of loggable strings from a full stack trace', make_loggable_stack);
        }


        private static function find_by_name():void
        {
            var callingFrame:CallStackInfo = CallUtil.findCallingStackFrame('find_by_name');

            it.expects(callingFrame.source).toEndWith('pixeldroid/bdd/models/Requirement.ls');
            it.expects(callingFrame.method.getName()).toEqual('test');
        }

        private static function fetch_by_distance():void
        {
            var callingFrame:CallStackInfo = CallUtil.getPriorStackFrame(0);

            it.expects(callingFrame.method.getName()).toEqual('fetch_by_distance');
        }

        private static function make_loggable_frame():void
        {
            var callingFrame:CallStackInfo = CallUtil.getPriorStackFrame(0);

            it.expects(CallUtil.toCallTrace(callingFrame)).toEqual('./src/spec//CallUtilSpec.ls(make_loggable_frame):40');
        }

        private static function make_loggable_stack():void
        {
            var loggableStack:Vector.<String> = CallUtil.traceCallStack();

            it.asserts(loggableStack.length).isGreaterThan(1);
            loggableStack.pop(); // get rid of the call to traceCallStack()
            it.expects(loggableStack.pop()).toEqual('./src/spec//CallUtilSpec.ls(make_loggable_stack):47');
        }
    }
}
