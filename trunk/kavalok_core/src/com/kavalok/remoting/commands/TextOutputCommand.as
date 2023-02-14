package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogRulesView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.commands.ServerCommandBase;
	
	public class TextOutputCommand extends ServerCommandBase
	{
		
		public function TextOutputCommand()
		{
		}
		
		override public function execute():void
		{
		    var text:String = String(parameter);
			Dialogs.showOkDialog("There was an error" + text, true);
		}
	
	}
}