package
{
    import loom.Application;
    import loom2d.display.StageScaleMode;
    import loom2d.ui.SimpleLabel;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;
    import pixeldroid.bdd.reporters.ConsoleReporter;


    public class Lspec extends Application
    {
        override public function run():void
        {
            trace('[Lspec] - run()');

            stage.scaleMode = StageScaleMode.LETTERBOX;
            addLabel();

            describeLSpec();
            describeExpectations();

            Spec.addReporter(new ConsoleReporter());
            Spec.execute();
            // TODO: work out error messaging (stack trace?)
            // TODO: add reporters (console, html, xml, json)
            // TODO: compare to minitest
        }

        private function describeLSpec():void
        {
            var it:Thing = Spec.describe('spec-loom');

            it.should('help declare expectations', function() {
                it.expects('this').not.toEqual('that');
            });
        }

        private function describeExpectations():void
        {
            var it:Thing = Spec.describe('Expectations');

            it.should('be executable', function() {
                var f:Function = function(a:Number,b:Number):Number { return a*b; };
                it.expects(f(5,7)).toEqual(5*7);
            });

            it.should('provide boolean matchers', function() {
                it.expects(true).toBeTruthy();
                it.expects(1).toBeTruthy();
                it.expects('a').toBeTruthy();
                it.expects({}).toBeTruthy();
                it.expects(function() {}).toBeTruthy();

                it.expects(false).toBeFalsey();
                it.expects(0).toBeFalsey();
                it.expects('').toBeFalsey();
                it.expects(null).toBeFalsey();
                it.expects(NaN).toBeFalsey();
            });

            it.should('provide a negation helper', function() {
                it.expects(false).not.toBeTruthy();
                it.expects(true).not.toBeFalsey();
                it.expects(true).not.not.toBeTruthy();
            });

            it.should('provide an equality matcher', function() {
                it.expects(true).toEqual(true);
                it.expects(false).not.toEqual(true);
                it.expects(1).toEqual(1);
                it.expects(2).not.toEqual(1);
                it.expects('a').toEqual('a');
                it.expects('A').not.toEqual('a');

                var d:Dictionary = {};
                it.expects(d).toEqual(d);
                it.expects(d).not.toEqual({});
                it.expects({}).not.toEqual({});
            });

            it.should('provide comparison matchers', function() {
                it.expects(3).toBeLessThan(5);
                it.expects(3).not.toBeLessThan(0);
                it.expects(3).toBeGreaterThan(-5);
                it.expects(3).not.toBeGreaterThan(3);
            });

            it.should('provide a null matcher', function() {
                it.expects(null).toBeNull();
                it.expects(0).not.toBeNull();
                it.expects('').not.toBeNull();
                it.expects(NaN).not.toBeNull();
            });

            it.should('provide a membership matcher', function() {
                var v:Vector.<String> = ['a', 'b', 'c'];
                it.expects(v).toContain('b');
                it.expects(v).not.toContain('q');
            });

            it.should('provide a type matcher', function() {
                it.expects(true).toBeA(Boolean);
                it.expects(9).toBeA(Number);
                it.expects('').toBeA(String);
                it.expects([]).toBeA(Vector);
                it.expects({}).toBeA(Dictionary);
                it.expects(function(){}).toBeA(Function);
                it.expects(it).toBeA(Thing);
                it.expects(it).not.toBeA(Object);
            });
        }


        private function addLabel():void
        {
            var label = new SimpleLabel("assets/Curse-hd.fnt");
            label.text = "spec-loom";
            label.center();
            label.x = stage.stageWidth / 2;
            label.y = stage.stageHeight / 2 - 100;
            stage.addChild(label);
        }
    }
}