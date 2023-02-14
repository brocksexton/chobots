package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogRulesView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.commands.ServerCommandBase;
	
	public class TimelineLoadFail extends ServerCommandBase
	{
		
		public function TimelineLoadFail()
		{
		}
		
		override public function execute():void
		{
			Dialogs.showOkDialog("Your timeline failed to load.", true);
			Global.isLocked = false;
		}
	
	}
}