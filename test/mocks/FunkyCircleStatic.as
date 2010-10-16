package mocks
{	
	import com.greensock.TweenLite;
	import mx.effects.easing.Bounce;
	
	public class FunkyCircleStatic extends FunkyCircleSymbol
	{

		public function scale(scale:Number):Number {
			return this.scaleX = this.scaleY = scale;
		}

		public function scaleTween(scale:Number, duration:Number):TweenLite {
			return TweenLite.to(this, duration, {scaleX:scale, scaleY:scale});
		}
		
		public function bounce(duration:Number):TweenLite
		{
			return TweenLite.to(this, duration, {y:-20, ease:Bounce.easeInOut});
		}
		
		
	}
}