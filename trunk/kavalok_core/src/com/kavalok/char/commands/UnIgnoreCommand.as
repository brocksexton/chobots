package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	public class UnIgnoreCommand extends CharCommandBase
	{
		override public function execute():void
		{
			var messaege:String = Strings.substitute(Global.messages.unIgnoreUserConfirm, char.id)
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(messaege);
			dialog.yes.addListener(doUnIgnore);
		}
		
		private function doUnIgnore():void
		{
			Global.charManager.ignores.removeChar(char.userId);
			Dialogs.showOkDialog(Strings.substitute(Global.messages.ignoreRemoved, char.id));
		}

	}
}