package yagni
{
	import flash.utils.describeType;
	
	/**
	 * Map a mixin to the current class.
	 * 
	 * Mixin's can be used when you are subclassing a symbol defined in a .fla file.
	 * It is very convenient to do, bit uses up your chance to add common functionality
	 * through a base class. In that case you can use a mixin, a class who's methods
	 * are added to your class in the constructor.
	 * 
	 * Mixin classes must have only static constants of type <code>Function</code>:
	 * <pre>
	 *   import com.greensock.TweenLite;
	 *
	 *   public class IsoMetricScaleMixin
	 *   {
	 *   	public static const scale:Function = function(scale:Number):Number {
	 *   		return this.scaleX = this.scaleY = scale;
	 *   	}
	 *
	 *   	public static const scaleTween:Function = function(scale:Number, duration:Number):TweenLite {
	 *   		return TweenLite.to(this, duration, {scaleX:scale, scaleY:scale});
	 *   	}
	 *   }
	 * </pre>
	 * 
	 * The symbol you are extending should then look like this:
	 * <pre>
	 *   import yagni.mixin;
	 *   import mixins.IsoMetricScaleMixin;
	 *   import mixins.BounceMixin;
	 * 
	 *   public class FunkyCircle extends FunkyCircleSymbol
	 *   {
	 *
	 *   	public var scale:Function;
	 *   	public var scaleTween:Function;
	 *   	public var bounce:Function;
	 * 
	 *   	public function FunkyCircle()
	 *   	{
	 *   		super();
	 *   		mixin(this, IsoMetricScaleMixin, BounceMixin);
	 *   	}
	 *
	 *   }
	 * </pre>
	 * 
	 * Note that <code>mixin</code> accepts multiple mixin classes.
	 * 
	 * After you've done that, you can create funky circles and do some scaling
	 * on them:
	 * 
	 * <pre>
	 * var funkyCircle:FunkyCircle = new FunkyCircle();
	 * funkyCircle.scale(2);
	 * funkyCircle.scaleTween(1);
	 * </pre>
	 * 
	 * 
	 * @param target The target should either have public member with the same
	 * names as the methods defined in the mixins, or be dynamic.
	 * @param rest the classes that need to be mixed into <code>target</code>
	 */
	
	public function mixin(target:Object, ... rest):void {
		for each (var Mixin:Class in rest) {
			for each (var func:String in describeType(Mixin).constant.(@type=='Function').@name) {
				target[func] = Mixin[func];
			}			
		}
	}
}