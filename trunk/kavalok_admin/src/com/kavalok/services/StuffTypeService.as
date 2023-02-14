package com.kavalok.services
{
	import com.kavalok.dto.stuff.StuffTypeAdminTO;
	
	public class StuffTypeService extends Red5ServiceBase
	{
		public function StuffTypeService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getStuffList(shopName:String):void
		{
			doCall("getStuffList", arguments);
		}
		
		public function getStuffListByShop(shopName : String):void
		{
			doCall("getStuffListByShop", arguments);
		}

		public function getShops():void
		{
			doCall("getShops", arguments);
		}
		
		public function saveItem(item:StuffTypeAdminTO):void
		{
			doCall("saveItem", arguments);
		}
	}
}