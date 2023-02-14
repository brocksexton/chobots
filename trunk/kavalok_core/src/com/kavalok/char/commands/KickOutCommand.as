package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.services.AdminService;
	
	public class KickOutCommand extends CharCommandBase
	{
		override public function execute():void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(Global.messages.kickUserConfirmation);
			dialog.yes.addListener(onKickUserAccept);
		}
		
		private function onKickUserAccept():void
		{
			new AdminService().kickUserOut(char.userId, false);
		}
	}
}