package com.kavalok.services
{
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	
	public class StuffServiceNT extends Red5ServiceBase
	{
		public function StuffServiceNT(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function retriveItemWithColor(staffName:String, color : int):void
		{
			privRetriveItemWithColor(staffName, color, Global.charManager.privKey);
			//doCall("retriveItemWithColor", arguments);
		}
		public function retriveItemByIdWithColor(staffId:int, color : int):void
		{
			privRetriveItemByIdWithColor(staffId, color, Global.charManager.privKey);
		//	doCall("retriveItemByIdWithColor", arguments);
		}
		public function retriveItem(staffName:String):void
		{
			privRetriveItem(staffName, Global.charManager.privKey);
			//doCall("retriveItem", arguments);
		}
		public function retriveItemById(staffId:int):void
		{
			privRetriveItemById(staffId, Global.charManager.privKey);
			//doCall("retriveItemById", arguments);
		}

		public function updateStuffItem(item : StuffItemLightTO) : void 
		{
			doCall("updateStuffItem", arguments);
		}
		
		public function getStuffTypes(shopName : String) : void
		{
			doCall("getStuffTypes", arguments);
		}
		
		public function removeItem(itemId:int):void
		{
			doCall("removeItem", arguments);
		}
		
		public function getItem(itemId:int):void
		{
			doCall("getItem", arguments);
		}

		public function getItemOfTheMonthType():void
		{
			doCall("getItemOfTheMonthType", arguments);
		}
		
		public function getStuffType(fileName:String):void
		{
			doCall("getStuffType", arguments);
		}

		public function getStuffTypeFromId(id:int):void
		{
			doCall("getStuffTypeFromId", arguments);
		}

		/*SECURED METHODS*/

		private function privRetriveItem(staffName:String, privKey:String):void
		{
			doCall("retriveItem", arguments);
		}

		private function privRetriveItemWithColor(staffName:String, color:int, key:String):void
		{
			doCall("retriveItemWithColor", arguments);
		}
		private function privRetriveItemByIdWithColor(staffId:int, color:int, key:String):void
		{
			doCall("retriveItemByIdWithColor", arguments);
		}

		private function privRetriveItemById(staffId:int, key:String):void
		{
			doCall("retriveItemById", arguments);
		}

	}
}