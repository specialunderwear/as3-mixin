package mocks
{	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	
	public class BounceMixin
	{
		public static const bounce:Function = function(duration:Number):TweenLite
		{
			return TweenLite.to(this, duration, {y:-20, ease:Bounce.easeInOut});
		}

	}
}