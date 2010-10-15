package mocks
{	
	public class StaticFunctionObject
	{
		public static const testConst:Function = function(message:String):String
		{
			return String(this) + message;
		};

		public static var testVar:Function = function(message:String):String
		{
			return String(this) + message;
		};

	}
}