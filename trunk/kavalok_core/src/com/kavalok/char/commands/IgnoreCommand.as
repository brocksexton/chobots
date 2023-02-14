package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.utils.Strings;
	
	public class IgnoreCommand extends CharCommandBase
	{
		override public function execute():void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
			}
			else
			{
				var message:String = Strings.substitute(Global.messages.ignoreUserConfirm, char.id);
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(message);
				dialog.yes.addListener(doIgnore);
			}
		}

		private function doIgnore():void
		{
			Global.charManager.ignores.addChar(char.userId);
			Dialogs.showOkDialog(Strings.substitute(Global.messages.ignoreAdded, char.id));
		}
	}
}