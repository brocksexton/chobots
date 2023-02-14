package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.utils.Strings;
	
	public class KickOutCommand extends ServerCommandBase
	{
		public function KickOutCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			var banned:Boolean = Boolean(parameter);
			if (banned)
				Dialogs.showOkDialog(Strings.substitute(Global.resourceBundles.kavalok.messages.kickOutBanned, Global.charManager.charId), false);
			else
				Dialogs.showOkDialog(Global.resourceBundles.kavalok.messages.kickOut, false);
			RemoteConnection.instance.disconnect();
		}
	}
}