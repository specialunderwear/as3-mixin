package mocks
{	
	import com.greensock.TweenLite;

	public class IsoMetricScaleMixin
	{
		public static const scale:Function = function(scale:Number):Number {
			return this.scaleX = this.scaleY = scale;
		}

		public static const scaleTween:Function = function(scale:Number, duration:Number):TweenLite {
			return TweenLite.to(this, duration, {scaleX:scale, scaleY:scale});
		}
	}
}