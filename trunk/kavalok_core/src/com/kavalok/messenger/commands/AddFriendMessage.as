package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;

	public class AddFriendMessage extends MessageBase
	{
		override public function execute():void
		{
			super.execute();
			Global.charManager.friends.refresh();
		}
		
		override public function getIcon():Class
		{
			return McMsgFriendsIcon;
		}
		
		override public function show():void
		{
			showInfo(Global.messages.message, getText());
		}
		
		override public function getText():String
		{
			return Strings.substitute(Global.messages.friendAdded, sender);
		}
		
	}
}