package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.char.Stuffs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.messenger.commands.GiftMessage;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.services.AdminService;
	
	public class RetriveStuffCommand
	{
		private var _itemName:String;
		private var _from:String;
		private var _color:Number;
		private var _completeEvent:EventSender = new EventSender(RetriveStuffCommand);
		
		public function RetriveStuffCommand(itemName:String, from:String, color:Number = NaN)
		{
			_itemName = itemName;
			_from = from;
			_color = color;
		}
		
		public function execute():void
		{
			Global.isLocked = true;
			new AdminService(gotKey).getNewPrivKey();

		}

		private function gotKey(result:String):void
		{
			Global.charManager.privKey = result;

			if (isNaN(_color))
				new StuffServiceNT(onResult).retriveItem(_itemName);
			else
				new StuffServiceNT(onResult).retriveItemWithColor(_itemName, _color);
		}
		
		private function onResult(item:StuffItemLightTO):void
		{
			stuffs.addItem(item);
			
			var message:GiftMessage = new GiftMessage();
			message.itemId = item.id;
			message.sender = _from;
			message.execute();
			
			Global.isLocked = false;
			_completeEvent.sendEvent(this);
		}
		
		private function get stuffs():Stuffs
		{
			return Global.charManager.stuffs;
		}
		
		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}
	}
}