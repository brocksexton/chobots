package com.kavalok.services
{

	public class SystemService extends Red5ServiceBase
	{

		public function SystemService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}

		public function getSystemDate():void
		{
			doCall("getSystemDate", arguments);
		}
		
		public function clientTick():void
		{
			doCall("clientTick", arguments);
		}
	}
}

