package com.kavalok.robotCombat.commands
{
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	
	public class OpponentDisconnectCommand extends ModuleCommandBase
	{
		public function OpponentDisconnectCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			var dialog:DialogOkView = Dialogs.showOkDialog(bundle.messages.opponentDisconnect);
			dialog.ok.addListener(onOk);
		}
		
		private function onOk():void
		{
			new QuitCommand().execute();
		}
		
	}
}