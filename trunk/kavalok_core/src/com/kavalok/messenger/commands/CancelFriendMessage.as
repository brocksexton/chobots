package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;

	public class CancelFriendMessage extends MessageBase
	{
		override public function show():void
		{
			showInfo(Global.messages.message, getText());
		}
		
		override public function getText():String
		{
			return Strings.substitute(Global.messages.friendCanceled, sender);
		}
	}
}