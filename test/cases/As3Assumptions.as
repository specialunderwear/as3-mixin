package cases
{	
	import mocks.ClassMethod;
	import org.flexunit.Assert;
	import mocks.packageFunction;
	import mocks.internalFunctionObject;
	import mocks.StaticFunctionObject;

	public class As3Assumptions
	{
		[Test]
		public function youCanNotRebindMethods():void
		{
			var instance:ClassMethod = new ClassMethod();

			Assert.assertTrue("Unfortunately methods can not be bound to any other class",
				instance.test.call(this, ' instance.test').indexOf('As3Assumptions') == -1)
		}
		
		[Test]
		public function youCanNotRebindPackageFunctions():void
		{
			Assert.assertTrue("Unfortunaely it is not possible to rebind a package function.",
				packageFunction.call(this, ' packageFunction').indexOf('As3Assumptions') == -1
			);
			Assert.assertFalse("package functions are always bound to global",
				packageFunction.call(this, ' packageFunction').indexOf('global') == -1
			);
		}
		
		[Test]
		public function youCanRebindPackageGlobalFunctionObjects():void
		{
			Assert.assertFalse("Package global function objects can be rebound",
				internalFunctionObject.call(this, ' internalFunctionObject').indexOf('As3Assumptions') == -1
			)
		}
		
		[Test]
		public function youCanRebindStaticFunctionObjects():void
		{
			Assert.assertFalse("Static constant function objects can be rebound",
				StaticFunctionObject.testConst.call(this, ' StaticFunctionObject.testConst').indexOf('As3Assumptions') == -1
			);
			Assert.assertFalse("Static function objects can be rebound",
				StaticFunctionObject.testVar.call(this, ' StaticFunctionObject.testVar').indexOf('As3Assumptions') == -1
			);
		}
	}
}