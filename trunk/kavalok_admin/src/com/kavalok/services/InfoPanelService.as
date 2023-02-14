package com.kavalok.services
{
	import com.kavalok.dto.infoPanel.InfoPanelAdminTO;
	
	public class InfoPanelService extends Red5ServiceBase
	{
		public function InfoPanelService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getEntities() : void
		{
			doCall("getEntities", arguments);
		}
		
		public function saveEntity(data:InfoPanelAdminTO):void
		{
			doCall("saveEntity", arguments);
		}
		
		public function showNow(infoId:int):void
		{
			doCall("showNow", arguments);
		}
	}
}