package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogRulesView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.commands.ServerCommandBase;

	public class SupaUsaCommand extends ServerCommandBase
	{
		
		public function SupaUsaCommand()
		{
		}

		override public function execute():void
		{
				Global.supaUsa = true;
				Dialogs.showOkDialog("Woohoo, you've been promoted to superuser!", true);
				trace(Global.supaUsa);
			
		}
		
	}
}