package com.kavalok.services
{
	import com.kavalok.remoting.RemoteObject;
	
	public class GraphityService extends Red5ServiceBase
	{
		public function GraphityService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function sendShape(wallId:String, state:Object) : void
		{
			doCall("sendShape", arguments);
		}
		
		public function getShapes(wallId:String):void
		{
			doCall("getShapes", arguments);
		}
		
		public function clear(wallId:String):void
		{
			doCall("clear", arguments);
		}
	}
}