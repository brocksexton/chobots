package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogRulesView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.commands.ServerCommandBase;
	
	public class TweetSuccess extends ServerCommandBase
	{
		
		public function TweetSuccess()
		{
		}
		
		override public function execute():void
		{
			Dialogs.showOkDialog("Tweet was sent successfully", true);
			Global.isLocked = false;
		}
	
	}
}