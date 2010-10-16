package cases
{	
	import mocks.FunkyCircle;
	import org.flexunit.Assert;
	import com.greensock.TweenLite;
	import flash.utils.getTimer;
	import mocks.FunkyCircleStatic;
	
	public class MixinTest
	{
		[Test]
		public function testMixinAddsScaleMethod():void
		{
			var a:FunkyCircle = new FunkyCircle();
			Assert.assertEquals('ScaleX should be 1 initially',
				1, a.scaleX
			);
			Assert.assertEquals('ScaleY should be 1 initially',
				1, a.scaleY
			);
			a.scale(2);
			Assert.assertEquals('ScaleX should be 2 now',
				2, a.scaleX
			);
			Assert.assertEquals('ScaleY should be 2 now',
				2, a.scaleY
			);
			
		}
		
		[Test]
		public function multipleMixinsArePossible():void
		{
			var a:FunkyCircle = new FunkyCircle();
			Assert.assertTrue('The bounce method from BounceMixin should be added as well',
				a.bounce(7) is TweenLite
			);
		}
		
		[Test]
		public function benchmark():void
		{
			var starttime: int;
			var staticInstance:FunkyCircleStatic;
			var mixedInstance:FunkyCircle;
			
			starttime = getTimer();
			for (var i:int = 0; i < 10000; i++) {
				staticInstance = new FunkyCircleStatic();
			}
			trace("MixinTest::benchmark() static construction",  starttime);
			starttime = getTimer();
			for (i = 0; i < 10000; i++) {
				mixedInstance = new FunkyCircle();
			}
			trace("MixinTest::benchmark() mixin construction",  starttime);
			starttime = getTimer();
			for (i = 0; i < 10000; i++) {
				staticInstance.scale(2);
			}
			trace("MixinTest::benchmark() static function calls",  starttime);

			starttime = getTimer();
			for (i = 0; i < 10000; i++) {
				mixedInstance.scale(2);
			}
			trace("MixinTest::benchmark() mixed in function calls",  starttime);
		}
	}
}