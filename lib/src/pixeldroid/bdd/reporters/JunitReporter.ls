
package pixeldroid.bdd.reporters
{
    import pixeldroid.bdd.Reporter;
    import pixeldroid.bdd.models.Expectation;
    import pixeldroid.bdd.models.MatchResult;
    import pixeldroid.bdd.models.SpecInfo;

    import system.xml.XMLDocument;
    import system.xml.XMLElement;


    /**
    Generates an xml report of the results of executing a specification.

    The xml format matches the schema introduced by JUnit, and commonly supported by CI tools like Jenkins.

    @see http://llg.cubic.org/docs/junit/
    @see https://github.com/windyroad/JUnit-Schema
    */
    public class JunitReporter implements Reporter
    {
        private var xml:XMLDocument;
        private var suites:XMLElement;
        private var numFailures:Number;


        /** @inherit */
        public function init(specInfo:SpecInfo):void
        {
            xml = new XMLDocument();
            xml.linkEndChild(xml.newDeclaration('xml version="1.0" encoding="UTF-8"'));
            xml.linkEndChild(xml.newComment(specInfo.toString()));

            suites = xml.newElement('testsuites');
            xml.linkEndChild(suites);
        }

        /** @inherit */
        public function begin(name:String, total:Number):void
        {
            numFailures = 0;

            suites.deleteChildren();
            suites.setAttribute('name', name);
            suites.setAttribute('tests', total.toString());
        }

        /** @inherit */
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
                    if (result.hasMessage()) fail.setAttribute('message', result.message +' (' +result.source +':' +result.line +')');

                    test.linkEndChild(fail);
                }

                suite.linkEndChild(test);
            }

            suites.linkEndChild(suite);
        }

        /** @inherit */
        public function end(name:String, durationSec:Number):Boolean
        {
            suites.setAttribute('errors', '0');
            suites.setAttribute('failures', numFailures.toString());
            suites.setAttribute('time', durationSec.toString());

            writeFile('TEST-' +name +'.xml');

            return (numFailures == 0);
        }

        /** @inherit */
        public function finalize(durationSec:Number):void
        {
            /* no-op */
        }


        private function writeFile(fileName:String):void
        {
            xml.saveFile(fileName);
        }
    }
}
