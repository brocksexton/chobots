package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.messenger.commands.InviteMessage;
	import com.kavalok.services.MessageService;
	
	public class FriendRequest extends CharCommandBase
	{
		override public function execute():void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
				new RegisterGuestCommand().execute();
			else if (Global.charManager.isFriendsFull)
				Dialogs.showOkDialog(Global.messages.friendsListFull)
			else
				sendRequest();
		}
		
		private function sendRequest():void
		{
			new MessageService().sendCommand(char.userId, new InviteMessage());
			Global.charManager.ignores.removeChar(char.userId, false);
			Dialogs.showOkDialog(Global.messages.addFriendSent);
		}
	}
}