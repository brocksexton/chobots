package com.kavalok.services
{
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.Global;
	
	public class StuffService extends Red5ServiceBase
	{
		public function StuffService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}

		public function buyItem(id:int, count:int = 1, color:int = -1, colorSec:int = -1) : void
		{
			doCall("buyItem", arguments);
		}
		
		public function buyItemEmeralds(id:int, count:int = 1, color:int = -1, colorSec:int = -1) : void
		{
			doCall("buyItemEmeralds", arguments);
		}
	}
}