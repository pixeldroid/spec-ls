spec-ls
=======

a simple specification framework for Loom

![spec-ls screenshot](terminal.png)


## installation

Download the library into its matching sdk folder:

    $ curl -L -o ~/.loom/sdks/sprint33/libs/Spec.loomlib \
        https://github.com/pixeldroid/spec-ls/releases/download/v1.1.2/Spec-sprint33.loomlib

To uninstall, simply delete the file:

    $ rm ~/.loom/sdks/sprint33/libs/Spec.loomlib


## usage

0. import Spec, a Reporter, and your specifications
0. have the specifications describe themselves to Spec
0. add your reporter(s) to Spec and execute

```ls
package
{
    import loom.Application;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.reporters.ConsoleReporter;


    public class SpecTest extends Application
    {

        override public function run():void
        {
            MySpec.describe();

            Spec.addReporter(new ConsoleReporter());
            Spec.execute();
        }
    }


    import pixeldroid.bdd.Thing;

    public static class MySpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('a Thing');

            it.should('exist', function() {
                it.expects(MySpec).not.toBeNull();
            });
        }
    }

}
```

### matchers

spec-ls has a basic set of expectation phrases for specifying behavior:

* `toEqual(value2:Object)`
* `toBeA(type:Type)`
* `toBeNaN()`
* `toBeNull()`
* `toBeTruthy()`
* `toBeFalsey()`
* `toBeLessThan(value2:Number)`
* `toBeGreaterThan(value2:Number)`
* `toContain(value2:Object)`
* `toBeEmpty()`
* `toBePlusOrMinus(absoluteDelta:Number).from(value2:Number)`

you can see them used in the specifications for spec-ls itself: [ExpectationSpec][ExpectationSpec.ls]

### reporters

spec-ls ships with three reporters:

* **AnsiReporter** - prints a compact summary to the console using ANSI color codes
* **ConsoleReporter** - traces the complete results with a minimum of frill
* **JunitReporter** - writes jUnit style xml summaries for CI systems like Jenkins and Bamboo

..or create your own by implementing the simple [Reporter][Reporter.ls] interface.


## working from source

first install [loomtasks][loomtasks]

### compiling

    $ rake lib:install

this will build the Spec library and install it in the currently configured sdk

### running tests

    $ rake test:run

this will build the Spec library, install it in the currently configured sdk, build the test app, and run the test app.


## contributing

Pull requests are welcome!


[ExpectationSpec.ls]: test/src/spec/ExpectationSpec.ls "ExpectationSpec.ls"
[Reporter.ls]: lib/src/pixeldroid/bdd/Reporter.ls "Reporter.ls"
[loomtasks]: https://github.com/pixeldroid/loomtasks "loomtasks"
