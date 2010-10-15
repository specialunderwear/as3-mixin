as3-mixin
=========

Mixin's can be used when you are subclassing a symbol defined in a .fla file.
It is very convenient to do, but uses up your chance to add common functionality
through a base class. In that case you can use a mixin, a class who's methods
are added to your class in the constructor.

Mixin classes must have only static constants of type ``Function``::

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

This is because you can only rebind ``this``, on function objects. If you don't
believe me, look at the tests.

The class with the symbol you are extending should look like this::

  import yagni.mixin;
  import mixins.IsoMetricScaleMixin;
  import mixins.BounceMixin;

  public class FunkyCircle extends FunkyCircleSymbol
  {
    // mixin forward declarations.
    public var scale:Function;
    public var scaleTween:Function;
    public var bounce:Function;

    public function FunkyCircle()
    {
        super();
        mixin(this, IsoMetricScaleMixin, BounceMixin);
    }

  }

Note that ``mixin`` accepts multiple mixin classes and that the mixin methods
are defined as public variables.

After you've done that, you can create funky circles and do some scaling
on them::

    var funkyCircle:Function = new FunkyCircle();
    funkyCircle.scale(2);
    funkyCircle.scaleTween(1);
