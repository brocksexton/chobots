package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.services.AdminService;
	
	public class DisableCharChat extends CharCommandBase
	{
		override public function execute():void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog("Are you sure you want to ban this user's chat for 5 minutes?");
			dialog.yes.addListener(onKickUserAccept);
		}
		
		private function onKickUserAccept():void
		{
			new AdminService().disableChatPeriod(char.userId, 1);
		}
	}
}