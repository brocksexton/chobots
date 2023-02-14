package com.kavalok.char
{
	import com.kavalok.events.EventSender;
	import com.kavalok.messenger.commands.IgnoreMessage;
	import com.kavalok.messenger.commands.UnignoreMessage;
	import com.kavalok.services.CharService;
	import com.kavalok.services.MessageService;
	
	public class Ignores
	{
		private var _refreshEvent:EventSender = new EventSender();
		private var _list:Array = [];
		
		public function Ignores()
		{
		}
		
		public function addChar(userId:Number, sendMessage:Boolean = false):void
		{
			new CharService(onResult).setIgnoreChar(userId);
			if (sendMessage)
				new MessageService().sendCommand(userId, new IgnoreMessage());
		}
		
		public function removeChar(userId:Number, sendMessage:Boolean = false):void
		{
			new CharService(onResult).removeIgnoreChar(userId);
			if (sendMessage)
				new MessageService().sendCommand(userId, new UnignoreMessage());
		}
		
		public function refresh():void
		{
			new CharService(onResult).getIgnoreList();
		}
		
		public function contains(charId:String):Boolean
		{
			return _list.indexOf(charId) >= 0;
		}
		
		private function onResult(result:Array):void
		{
			list = result;
		}

		public function get list():Array { return _list; }
		
		public function set list(value:Array):void
		{
			 _list = value;
			 _refreshEvent.sendEvent();
		}
		
		public function get refreshEvent():EventSender { return _refreshEvent; }
	}
}