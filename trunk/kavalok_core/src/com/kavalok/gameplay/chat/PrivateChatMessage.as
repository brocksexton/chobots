package com.kavalok.gameplay.chat
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.gameplay.windows.CharWindowView;
	import com.kavalok.gameplay.windows.ShowCharViewCommand;
	import com.kavalok.messenger.commands.MessageBase;

	public class PrivateChatMessage extends MessageBase
	{
		public function PrivateChatMessage(notification : Notification)
		{
			super();
			this.sender = notification.fromLogin;
			this.senderUserId = notification.fromUserId;
			this.text = notification.getText();
		}
		
		override public function execute():void
		{
			var window:CharWindowView = Global.windowManager.getCharWindow(sender);
			
			if(window && window.visible)
				window.showChat(true);
			else
				super.execute();
		}
		
		override public function getTooltip():String
		{
			 return getText();
		}
		
		override public function show():void
		{
			var command:ShowCharViewCommand = new ShowCharViewCommand(sender, senderUserId, null, true);
			command.showChat = true; 
			command.execute();
		}
	}
}