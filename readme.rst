as3-mixin
=========

Mixin's for subclassing symbols
-------------------------------

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

    var funkyCircle:FunkyCircle = new FunkyCircle();
    funkyCircle.scale(2);
    funkyCircle.scaleTween(1);

Mixin's for doing layout in the fla
-----------------------------------

The above described method for doing graphics is very handy for small symbols.
When your UI becomes more intricate and symbols are getting nested, the code for
one symbol can grow a lot. You don't want to include the code for all the subsymbols
in the same file. What you want is to define the behaviour of the subsymbols in
a separate file. 

Base classes for sub symbols
++++++++++++++++++++++++++++

A very flawed attempt at factoring out behaviour for symbols in separate files,
is to have user defined base classes for your symbols. It is possible set the
base class of a symbol in the fla, to one of your own classes. The problem with
this approach, is that there isvey hard to see if code is being used or not. When
you change stuff in the fla, your base classes might become obsolete, without you
noticing.

Or the other way around, you might delete a file for which you can not find a reference
anywhere in your code base, only to find out it is still being used when you try to
recompile the fla.

Mixin's for sub symbols
+++++++++++++++++++++++

Mixin's are a much better option. If you leave the type of your symbols set to
``MovieClip``, since ``MovieClip`` is dynamic, you can add behaviour by mixin in
methods::

    import yagni.mixin;
    import mixins.IsoMetricScaleMixin;
    import mixins.BounceMixin;

    public class Layout extends LayoutSymbol
    {
      public function FunkyCircle()
      {
          super();
          
          // LayoutSymbol has an instance variable named square,
          // which is of the default type for symbols, MovieClip
          mixin(super.square, IsoMetricScaleMixin);
      }

    }

The instance variable square will get the behaviour defined in IsoMetricScaleMixin,
which allows you to call ``super.square.scale(2);`` inside Layout. This way you
can factor out the behaviour of sub symbols and not find any unpleasant surprises
when you compile your fla.

Performance
-----------

You can see what the performance is for regular objects versus objects with mixins
by running the test suit::

    make test
    
Try typing that in the root folder.