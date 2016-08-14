
package pixeldroid.bdd.reporters
{
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.bdd.models.SpecInfo;

    import system.xml.XMLDocument;
    import system.xml.XMLElement;


    public class JunitReporter implements Reporter
    {
        private var xml:XMLDocument;
        private var suites:XMLElement;
        private var numFailures:Number;


        public function init(specInfo:SpecInfo):void
        {
            xml = new XMLDocument();
            xml.linkEndChild(xml.newDeclaration('xml version="1.0" encoding="UTF-8"'));
            xml.linkEndChild(xml.newComment(specInfo.toString()));

            suites = xml.newElement('testsuites');
            xml.linkEndChild(suites);
        }

        public function begin(name:String, total:Number):void
        {
            numFailures = 0;

            suites.deleteChildren();
            suites.setAttribute('name', name);
            suites.setAttribute('tests', total.toString());
        }

        public function report(e:Expectation, durationSec:Number, index:Number, total:Number):void
        {
            var i:Number;
            var n:Number = e.numResults;
            var result:MatchResult;

            var suite:XMLElement = xml.newElement('testsuite');
            suite.setAttribute('name', e.description);
            suite.setAttribute('time', durationSec.toString());

            var test:XMLElement;
            var fail:XMLElement;

            for (i = 0; i < n; i++)
            {
                result = e.getResult(i);

                test = xml.newElement('testcase');
                test.setAttribute('name', 'expect ' +result.description);

                if (!result.success)
                {
                    numFailures++;

                    fail = xml.newElement('failure');
                    fail.setAttribute('type', 'assertion');
                    if (result.hasMessage()) fail.setAttribute('message', result.message);

                    test.linkEndChild(fail);
                }

                suite.linkEndChild(test);
            }

            suites.linkEndChild(suite);
        }

        public function end(name:String, durationSec:Number):Boolean
        {
            suites.setAttribute('errors', '0');
            suites.setAttribute('failures', numFailures.toString());
            suites.setAttribute('time', durationSec.toString());

            writeFile('TEST-' +name +'.xml');

            return (numFailures == 0);
        }


        private function writeFile(fileName:String):void
        {
            xml.saveFile(fileName);
        }
    }
}
