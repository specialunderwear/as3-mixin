package mocks
{
	public var internalFunctionObject:Function = printThis
}

internal function printThis(message:String):String
{
	return String(this) + message;
}
