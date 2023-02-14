package com.kavalok.services
{
	public class LogService extends Red5ServiceBase
	{
		public function LogService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function adminLog(action : String, success : int, type:String) : void
		{
			doCall("amL", arguments);
		}

		public function toolsLog(action : String, recipientId : int, recipient:String, type:String) : void
		{
			doCall("tlG", arguments);
		}

		public function giftLog(item:String, recipientId:int, recipient:String, itemId:int):void
		{
			doCall("gL", arguments);
		}
		
		public function logTrade(item:String, partnerId:int, partner:String, itemIds:String):void
		{
		    doCall("lT", arguments);
	    }
		
		
	}
}