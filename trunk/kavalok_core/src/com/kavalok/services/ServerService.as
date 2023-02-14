package com.kavalok.services
{
	public class ServerService extends Red5ServiceBase
	{
		public function ServerService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getServerAddress(name : String) : void
		{
			doCall("getServerAddress", arguments);
		}
		public function getAllServers() : void
		{
			doCall("getAllServers", arguments);
		}
		public function getServers() : void
		{	
			doCall("getServers", arguments);
		}
		
	}
}