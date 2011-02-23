package mocks
{	
	import yagni.mixin;
	import mocks.IsoMetricScaleMixin;
	import mocks.BounceMixin;
	import flash.display.MovieClip;
	
	public class FunkyCircle extends FunkyCircleSymbol
	{
		
		public var scale:Function;
		public var scaleTween:Function;
		public var bounce:Function;
		
		public function FunkyCircle()
		{
			super();
			mixin(this, IsoMetricScaleMixin, BounceMixin);
		}

	}
}