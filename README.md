spec-ls
=======

a simple specification framework for Loom

```
[Spec v1.0.0] execute()

Spec
should be versioned (1/2)
. expect '1.0.0' not toBeEmpty
should help declare expectations (2/2)
. expect 'this' not toEqual 'that'

Expectations
should be executable (1/10)
. expect '35' toEqual '35'
should provide boolean matchers (2/10)
. expect 'true' toBeTruthy
. expect '1' toBeTruthy
. expect 'a' toBeTruthy
. expect 'Object:system.Dictionary' toBeTruthy
. expect 'system.Function' toBeTruthy
. expect 'false' toBeFalsey
. expect '0' toBeFalsey
. expect '' toBeFalsey
. expect 'null' toBeFalsey
. expect 'nan' toBeFalsey
should provide a negation helper (3/10)
. expect 'false' not toBeTruthy
. expect 'true' not toBeFalsey
. expect 'true' toBeTruthy
should provide an equality matcher (4/10)
. expect 'true' toEqual 'true'
. expect 'false' not toEqual 'true'
. expect '1' toEqual '1'
. expect '2' not toEqual '1'
. expect 'a' toEqual 'a'
. expect 'A' not toEqual 'a'
. expect 'Object:system.Dictionary' toEqual 'Object:system.Dictionary'
. expect 'Object:system.Dictionary' not toEqual 'Object:system.Dictionary'
. expect 'Object:system.Dictionary' not toEqual 'Object:system.Dictionary'
should provide inequality matchers (5/10)
. expect 3 toBeLessThan 5
. expect 3 not toBeLessThan 0
. expect 3 toBeGreaterThan -5
. expect 3 not toBeGreaterThan 3
should provide a range matcher (6/10)
. expect -3 toBePlusOrMinus 5 from 0
. expect 3 not toBePlusOrMinus 2 from 0
should provide a null matcher (7/10)
. expect 'null' toBeNull
. expect '0' not toBeNull
. expect '' not toBeNull
. expect 'nan' not toBeNull
should provide an empty matcher (8/10)
. expect [] toBeEmpty
. expect '' toBeEmpty
. expect [1,2,3] not toBeEmpty
. expect 'abc' not toBeEmpty
should provide a membership matcher (9/10)
. expect [a,b,c] toContain 'b'
. expect [a,b,c] not toContain 'q'
. expect 'abc' toContain 'b'
. expect 'abc' not toContain 'q'
. expect 'the quick brown fox' toContain 'brown'
. expect 'the quick brown fox' not toContain 'dog'
should provide a type matcher (10/10)
. expect 'system.Boolean' toBeA 'system.Boolean'
. expect 'system.Number' toBeA 'system.Number'
. expect 'system.String' toBeA 'system.String'
. expect 'system.Vector' toBeA 'system.Vector'
. expect 'system.Dictionary' toBeA 'system.Dictionary'
. expect 'system.Function' toBeA 'system.Function'
. expect 'pixeldroid.bdd.Thing' toBeA 'pixeldroid.bdd.Thing'
X expect 'pixeldroid.bdd.Thing' toBeA 'system.Object'
```


## installation

Download the library into its matching sdk folder:

```bash
$ curl -L -o ~/.loom/sdks/sprint31/libs/Spec.loomlib \
    https://github.com/pixeldroid/spec-ls/releases/download/v1.0.0/Spec-sprint31.loomlib
```

To uninstall, simply delete the file:

```bash
$ rm ~/.loom/sdks/sprint31/libs/Spec.loomlib
```


## usage

0. import Spec, a Reporter, and your specifications
0. have the specifications describe themselves to Spec
0. add your reporter(s) to Spec and execute

```as3
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


## compiling from source

```bash
$ ./lib --build --run
```

this will build the Spec library, install it in the currently configured sdk, build the test app, and run the test app.
