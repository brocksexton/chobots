package com.kavalok.services
{
	public class InfoPanelService extends Red5ServiceBase
	{
		public function InfoPanelService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getAvailableList():void
		{
			doCall("getAvailableList", arguments);
		}
		
	}
}