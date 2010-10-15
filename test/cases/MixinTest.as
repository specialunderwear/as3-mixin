package cases
{	
	import mocks.FunkyCircle;
	import org.flexunit.Assert;
	import com.greensock.TweenLite;
	
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
			Assert.assertEquals('ScaleX should be 2 now',
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
	}
}