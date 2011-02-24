package mocks
{	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	
	public class PrivateArrayMixin
	{
		public static const arrayLength:Function = function():int
		{
			return this._array.length;
		}

	}
}