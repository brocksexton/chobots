package com.kavalok.remoting.commands
{
	import com.kavalok.dialogs.DialogRulesView;
	import com.kavalok.remoting.commands.ServerCommandBase;

	public class ShowRulesCommand extends ServerCommandBase
	{
		
		public function ShowRulesCommand()
		{
		}

		override public function execute():void
		{
			var dialog : DialogRulesView = new DialogRulesView();
			dialog.show();
		}
		
	}
}