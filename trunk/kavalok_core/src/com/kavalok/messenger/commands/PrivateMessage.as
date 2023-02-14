package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	
	public class PrivateMessage extends MessageBase
	{
		private var _message:Object;
		
		override public function execute():void
		{
			Global.notifications.receiveChat(sender, senderUserId, _message, Global.charManager.charId, Global.charManager.userId);
		} 
		
		public function get message() : Object
		{
			return _message;
		}
		
		public function set message(value : Object) : void
		{
			if(value is String)
				text = value as String;
			
			_message = value;
		}
			
		
	}
}