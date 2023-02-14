package com.kavalok.utils
{
	import com.kavalok.utils.timers.CallFunctionAction;
	
	public final class Timers
	{
		public static var errorHandler:Function;
		
		public static function callAfter(func : Function, interval : uint = 100, thisObject : Object = null, arguments : Array = null) : void
		{
			var command : CallFunctionAction = (errorHandler == null)
				? new CallFunctionAction(func, interval, thisObject, arguments)
				: new CallFunctionAction(getHandledDelegate(func, thisObject, arguments), interval);
			
			command.execute();
		}
		
		private static function getHandledDelegate(func:Function, thisObject:Object, args:Array):Function
		{
			return function():void
			{
				try {
					func.apply(thisObject, args);
				} catch (e:Error) {
					errorHandler(e);
				}
			}
		}
	}
}