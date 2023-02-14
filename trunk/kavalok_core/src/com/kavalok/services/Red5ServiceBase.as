package com.kavalok.services
{
	import com.kavalok.remoting.BaseRed5Delegate;

	public class Red5ServiceBase extends BaseRed5Delegate
	{
		public static var defaultResultHandler:Function = onResult;
		
		public function Red5ServiceBase(resultHandler:Function = null, faultHandler:Function = null)
		{
			super(resultHandler == null? defaultResultHandler : resultHandler, faultHandler);
		}
		
		override protected function doCall(methodName:String, args:Array):void
		{
			//args.unshift(AuthenticationManager.instance.email);
			super.doCall(methodName, args);
			//trace(methodName);
		}
		private static function onResult(result : Object):void{}
		
		
	}
}