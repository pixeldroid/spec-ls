
package pixeldroid.bdd.reporters
{
	import pixeldroid.ansi.ANSI;
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.models.Expectation;
	import pixeldroid.bdd.models.MatchResult;
	import pixeldroid.bdd.models.SpecInfo;


	public class AnsiReporter implements Reporter
	{
		private const lineWidth:Number = 60;

		private var failures:Dictionary.<Expectation, Vector.<Number>>;
		private var numSpecs:Number;
		private var numAssert:Number;

		private var ansi:ANSI = new ANSI();
		private var progress:String;
		private var numChars:Number;


		public function init(specInfo:SpecInfo):void
		{
			failures = {};
			numAssert = 0;

			ansi.clear;
			ansi.faint.add('[').nofaint.add(specInfo.name +' v' +specInfo.version).faint.add(']');
			ansi.add(' seed: ').nofaint.fgCyan.add(specInfo.seed.toString()).reset;

			trace('');
			trace(ansi);
		}

		public function begin(name:String, total:Number):void
		{
			numSpecs = total;

			progress = ansi.clear.bold.add(name).nobold.add(' ').toString();
			numChars = name.length + 1;

			trace('');
			trace(''); // overwriting will start on this line
		}

		public function report(e:Expectation, durationSec:Number, index:Number, total:Number):void
		{
			var i:Number;
			var n:Number = e.numResults;
			var result:MatchResult;

			numAssert += n;

			for (i = 0; i < n; i++)
			{
				ansi.clear.add(progress);

				result = e.getResult(i);
				if (result.success)
				{
					ansi.faint.add('.').nofaint;
					numChars++;
				}
				else
				{
					if (failures[e]) failures[e].push(i);
					else failures[e] = [i];

					ansi.bold.fgRed.add('X').nofg.nobold;
					numChars++;
				}

				progress = ansi.toString();
				trace(ansi.clear.overwrite.add(progress));

				if (numChars > lineWidth)
				{
					numChars = 0;
					progress = '';
					trace(''); // overwriting will continue on this new line
				}
			}
		}

		public function end(name:String, durationSec:Number):void
		{
			var failMessages:Vector.<String> = collectFailures();
			var numFailures:Number = failMessages.length;

			trace('');
			ansi.clear;

			if (numFailures == 0) ansi.fgGreen;
			else ansi.bold.fgRed;

			ansi.add(' ' +numFailures +' ' +pluralize('failure', numFailures)).reset;
			ansi.faint.add(' in ').nofaint.add(numAssert +' assertions');
			ansi.faint.add(' from ').nofaint.add(numSpecs +' expectations');
			ansi.faint.add('.').nofaint;

			trace(ansi);

			for each (var s:String in failMessages)
			{
				trace(s);
			}
		}


		private function collectFailures():Vector.<String>
		{
			var v:Vector.<String> = [];
			var result:MatchResult;

			for (var e:Expectation in failures)
			{
				var resultIndices:Vector.<Number> = failures[e];
				for each (var i:Number in resultIndices)
				{
					result = e.getResult(i);
					ansi.clear.fgRed.add(' "' +e.description +'" ').faint.add('expected ').nofaint.add(result.message).reset;
					v.push(ansi.toString());
				}
			}

			return v;
		}

		private function pluralize(s:String, n:Number):String
		{
			if (n == 0 || n > 1) return s +'s';
			return s;
		}
	}
}
