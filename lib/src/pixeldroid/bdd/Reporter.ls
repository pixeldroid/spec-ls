
package pixeldroid.bdd
{
	import pixeldroid.bdd.models.Expectation;

	public interface Reporter
	{
		function begin(name:String, total:Number):void;
		function report(expectation:Expectation, index:Number, total:Number):void;
		function end():void;
	}
}
