package
{
    import loom.Application;
    import loom2d.display.StageScaleMode;
    import loom2d.ui.SimpleLabel;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;
    import pixeldroid.bdd.reporters.ConsoleReporter;

    import ExpectationSpec;
    import LspecSpec;


    public class Lspec extends Application
    {
        private var label:SimpleLabel;

        override public function run():void
        {
            stage.scaleMode = StageScaleMode.LETTERBOX;
            label = stage.addChild(new SimpleLabel("assets/Curse-hd.fnt")) as SimpleLabel;
            centeredMessage(label, this.getFullTypeName());

            LspecSpec.describe();
            ExpectationSpec.describe();

            Spec.addReporter(new ConsoleReporter());
            Spec.execute();

            // TODO: work out error messaging (stack trace?)
            // TODO: add summary notes (Y / X failed)
            // TODO: add reporters (console, html, xml, json)
            // TODO: compare to minitest
        }

        private function centeredMessage(label:SimpleLabel, msg:String):void
        {
            label.text = msg;
            label.center();
            label.x = stage.stageWidth / 2;
            label.y = (stage.stageHeight / 2) - (label.height / 2);
        }
    }
}