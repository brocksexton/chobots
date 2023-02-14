package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.dialogs.Dialogs;
	
	public class ServerMaintenance extends ServerCommandBase
	{
		
		public function ServerMaintenance()
		{
			super();
		}
		
		override public function execute():void
		{
			Dialogs.showOkDialog("The Chobots World has gone offline for maintenance. See you soon!", false);
			RemoteConnection.instance.disconnect();
		}
	
	}
}

