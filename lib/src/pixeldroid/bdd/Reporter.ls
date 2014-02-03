
package pixeldroid.bdd
{
	import pixeldroid.bdd.models.Expectation;
	import pixeldroid.bdd.models.SpecInfo;

	public interface Reporter
	{
		function init(specInfo:SpecInfo):void;
		function begin(name:String, total:Number):void;
		function report(expectation:Expectation, durationSec:Number, index:Number, total:Number):void;
		function end(name:String, duration:Number):void;
	}
}
