Nifty tricks with as3-mixin
===========================

note!

Mixin's can never access private variables!

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
this approach, is that it is very hard to see if code is being used or not. When
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
      public function Layout()
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

Mixins as delegates
-------------------

You can also use mixin's to implement a delegate mechanism::

    package
    {   
        import yagni.mixin;

        public class GeneralTable
        {
            public var data:Array = [
                [0x1F9925, 0x992553],
                [0x252C99, 0x961099]
            ];
            
            public function GeneralTable(data:Array=null) {
                if (data)
                    this.data = data;
            }
            
            // delegate method default
            public var addObjectAtRowAndCol:Function = function(row:Number, col:Number):void {
                var a:Shape = new Shape();
                with (a.graphics) {
                    beginFill(this.data[row][col],1);
                    drawRect(0, 0, 20, 40);
                    endFill();
                }
                a.x = col * 40;
                a.y = row * 20;
                this.addChild(a);
            }
            
            // delegate setter
            public function set delegate(delegate:Object):void
            {
                mixin(this, delegate);
            }
        
            // draw uses the delegate method to draw the table cells.
            public function draw():void
            {
                for (var i:int = 0; i < data.length; i++) {
                    for (var j:int = 0; j < data[i].length; j++) {
                        this.addObjectAtRowAndCol(i, j);
                    }
                }
            }
        }

    }

Above you can see a general, very unsophisticated, table implementation.
In the above case, calling ``draw()`` after construction will draw a 2x2 table,
with cells in different colours.

There is only one method that determines exactly what is being drawn in each cell,
and where; ``addObjectAtRowAndCol``. This method can be overridden by setting the
proper delegate object to the ``delegate`` setter. The delegate object should be
a mixin that defines the ``addObjectAtRowAndCol`` function object::

    public class TableDelegate
    {
        // using this delegate would fill the table with funky circles as cells!
        public static const addObjectAtRowAndCol:Function = function(row:Number, col:Number):void
        {
            var c:FunkyCircle = new FunkyCircle()
            c.x = col * 100;
            c.y = row * 100;
            this.addChild(c);
        }

    }

The advantage of doing it this way instead of extending the ``GeneralTable`` and
overriding the ``addObjectAtRowAndCol`` method, is that setting the delegate works,
even when the ``GeneralTable`` is allready used in other code. This will save you
having to extend a whole bunch of classes, when the class you really want to override
is inside a whole bunch of other classes.

Delegate as sub object
----------------------

Traditional approaches would define the delegate as a sub object of ``GeneralTable``,
which would complicate your code::

    public class GeneralTable
    {
        
        // the delegate is a subobject, that defines addObjectAtRowAndCol.
        public var delegate:ObjectAtRowDelegate;

        // draw would call addObjectAtRowAndCol on the subobject.
        public function draw():void
        {
            for (var i:int = 0; i < data.length; i++) {
                for (var j:int = 0; j < data[i].length; j++) {
                
                    // Complicated code!
                    this.delegate.addObjectAtRowAndCol(this, i, j);
                }
            }
        }
    
    }

If you want to delagate a method that also belongs to your public api, you would
have to call the method like this::

    var table:GeneralTable = new GeneralTable();
    table.delegate.addObjectAtRowAndCol(table, 1, 2);
    
With a mixin as a delegate you can just go for::

    var table:GeneralTable = new GeneralTable();
    table.addObjectAtRowAndCol( 1, 2);

In short, using mixins as delegate, enables you to let delegates override part
of your class it's public api, without complicating things.

Performance
-----------

You can see what the performance is for regular objects versus objects with mixins
by running the test suit::

    make test
    
Try typing that in the root folder.

