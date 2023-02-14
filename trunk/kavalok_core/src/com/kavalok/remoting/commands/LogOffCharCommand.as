package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.utils.Strings;
	
	public class LogOffCharCommand extends ServerCommandBase
	{
		public function LogOffCharCommand()
		{
			super();
		}
		
		override public function execute():void
		{
        	Dialogs.showOkDialog(Global.resourceBundles.kavalok.messages.kickOut);
			RemoteConnection.instance.disconnect();
		}
	}
}