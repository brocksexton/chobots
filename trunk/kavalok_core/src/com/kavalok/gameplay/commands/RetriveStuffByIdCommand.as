package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.char.Stuffs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.messenger.commands.GiftMessage;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.services.AdminService;
	
	public class RetriveStuffByIdCommand
	{
		private var _itemId:int;
		private var _from:String;
		private var _color:Number;
		
		public function RetriveStuffByIdCommand(id:int, from:String, color:Number = NaN)
		{
			_itemId = id;
			_from = from;
			_color = color;
		}
		
		public function execute():void
		{
			Global.isLocked = true;
			new AdminService(gotKey).getNewPrivKey();
			
		
		}

		private function gotKey(val:String):void
		{
			Global.charManager.privKey = val;
			if (isNaN(_color))
				new StuffServiceNT(onResult).retriveItemById(_itemId);
			else
				new StuffServiceNT(onResult).retriveItemByIdWithColor(_itemId, _color);
		}
		
		private function onResult(item:StuffItemLightTO):void
		{
			stuffs.addItem(item);
			
			var message:GiftMessage = new GiftMessage();
			message.itemId = item.id;
			message.sender = _from;
			message.execute();
			
			Global.isLocked = false;
		}
		
		public function get stuffs():Stuffs
		{
			return Global.charManager.stuffs;
		}
	}
}