package pixeldroid.platform
{

    import system.CallStackInfo;
    import system.Debug;

    public final class CallUtils
    {
        private static var callStack:Vector.<CallStackInfo>;

        /**
        Search backwards through the call stack for the most recent caller of the provided method name.

        @param methodName Name of the method to find a caller for
        @return CallStackInfo or null
        */
        public static function findCallingStackFrame(methodName:string):CallStackInfo
        {
            callStack = Debug.getCallStack();
            var stackFrame:Number = callStack.length - 1;
            var csi:CallStackInfo;

            // search from the top of the callstack (most recently called)
            while (stackFrame-- > 0)
            {
                csi = callStack[stackFrame];

                if (csi.method.getName() == methodName)
                {
                    csi = callStack[stackFrame + 1];
                    return csi;
                }
            }

            // method not found
            csi = null;
            return csi;
        }

        /**
        Retrieve a stack frame some distance relative to the current one.

        For example, assuming in the chain below that method `bar()` calls `getPriorStackFrame()`, then
        the valid distance values would be as follows:
        ```
        ConsoleApplication.initialize()->Example.run()->Bat.baz()->Foo.bar()->CallUtils.getPriorStackframe()
                                     3              2          1          0                              -1
        ------------------------------------------------------------------^
        ```

        Out of bound values return null.

        The table below shows the call stack for the example above, and which stack frame a given value
        of `n` would retrieve the `CallStackInfo` for:
        ```
         n  stack frame
         -  -----------
         3  ./src/system//Application/ConsoleApplication.ls(initialize):35
         2  ./src/app//Example.ls(run):22
         1  ./src/app//Bat.ls(baz):111
         0  ./src/app//Foo.ls(bar):9
        -1  ./src/.//pixeldroid/platform/CallUtils.ls(getPriorStackFrame):67
        ```
        */
        public static function getPriorStackFrame(n:Number = 1):CallStackInfo
        {
            if (n < -1)
                return null;

            var stackFrame:Number = n + 1; // add one to account for calling this method
            callStack = Debug.getCallStack();

            if (stackFrame >= callStack.length)
                return null;

            return callStack[stackFrame];
        }

        /**
        Generate a human readable single line trace of the provided method call info.

        The trace line includes method source file, method name, and line number, e.g.:
        `./src/.//pixeldroid/platform/CallUtils.ls(toCallTrace):82`

        @param csi `CallStackInfo` instance to create trace line for
        */
        public static function toCallTrace(csi:CallStackInfo):String
        {
            return (csi.source +'(' +csi.method.getName() +'):' +csi.line);
        }

        /**
        Prepare a vector of single line strings representing a printable version of the current call stack.

        @return Vector.<String>
        */
        public static function traceCallStack():Vector.<String>
        {
            callStack = Debug.getCallStack();
            var lines:Vector.<String> = [];

            while (callStack.length > 0)
                lines.push(toCallTrace(callStack.pop()));

            return lines;
        }
    }
}
