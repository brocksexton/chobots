package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	
	public class FriendListFull extends MessageBase
	{
		override public function getTooltip():String
		{
			return Global.messages.friendListFull;
		}
		
		override public function show():void
		{
			showInfo(sender, getText());
		}
		
		override public function getText():String
		{
			return Global.messages.friendListFull;	
		}
		
	}
}