package cases
{	
	import mocks.FunkyCircle;
	import org.flexunit.Assert;
	import com.greensock.TweenLite;
	import flash.utils.getTimer;
	import mocks.FunkyCircleStatic;
	import yagni.mixin;
	import mocks.IsoMetricScaleMixin;
	import Runner;
	import mx.core.FlexGlobals;
	
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
		public function mixinOnInstancesInFlaWorks():void
		{
			var a:FunkyCircle = new FunkyCircle();
			mixin(a.square, IsoMetricScaleMixin);
			
			Assert.assertEquals('Before the scale the width of the square instance should be 60',
				a.square.width, 60
			);
			
			a.square.scale(1);
			
			Assert.assertEquals('The scale of the square instance is back to 1, so its width is back to 166',
				a.square.width, 166
			);
			
			Assert.assertEquals('The height should be the same as the width because scaling is isometric',
				a.square.width, a.square.height
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
			
			FlexGlobals.topLevelApplication.results += "MixinTest::benchmark() regular construction, 10.000 instances: " +  starttime + "ms.\n";

			starttime = getTimer();
			for (i = 0; i < 10000; i++) {
				mixedInstance = new FunkyCircle();
			}

			FlexGlobals.topLevelApplication.results += "MixinTest::benchmark() mixin construction, 10.000 instances: " +  starttime + "ms.\n";

			starttime = getTimer();
			for (i = 0; i < 10000; i++) {
				staticInstance.scale(i);
			}
			
			FlexGlobals.topLevelApplication.results += "MixinTest::benchmark() regular function calls, 10.000 calls: " +  starttime + "ms.\n";

			starttime = getTimer();
			for (i = 0; i < 10000; i++) {
				mixedInstance.scale(i);
			}
			
			FlexGlobals.topLevelApplication.results += "MixinTest::benchmark() mixed in function calls, 10.000 calls: " +  starttime + "ms.\n";
		}
	}
}