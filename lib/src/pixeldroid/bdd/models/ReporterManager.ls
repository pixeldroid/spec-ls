
package pixeldroid.bdd.models
{
	import pixeldroid.bdd.Reporter;
	import pixeldroid.bdd.models.SpecInfo;


	public class ReporterManager implements Reporter
	{
		private var reporters:Vector.<Reporter> = [];


		public function add(reporter:Reporter):void
		{
			reporters.push(reporter);
		}


		public function init(specInfo:SpecInfo):void
		{
			for each (var reporter:Reporter in reporters)
			{
				reporter.init(specInfo);
			}
		}

		public function begin(name:String, total:Number):void
		{
			for each (var reporter:Reporter in reporters)
			{
				reporter.begin(name, total);
			}
		}

		public function report(e:Expectation, index:Number, total:Number):void
		{
			for each (var reporter:Reporter in reporters)
			{
				reporter.report(e, index, total);
			}
		}

		public function end():void
		{
			for each (var reporter:Reporter in reporters)
			{
				reporter.end();
			}
		}
	}
}

