package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	public class FriendOnlineCommand extends ServerCommandBase
	{
		override public function execute():void
		{
			var friend:String = String(parameter);
			
			Global.frame.showNotification(Global.upperCase(friend) + " is now online.", "friend");
			trace(Global.charManager.charId + " has received the ntification!!!!");
		}
	}
}