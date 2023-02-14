package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogRulesView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.commands.ServerCommandBase;

	public class TweetFail extends ServerCommandBase
	{
		
		public function TweetFail()
		{
		}

		override public function execute():void
		{
				Dialogs.showOkDialog("Oh no, there was an error with sending your tweet.", true);
				Global.isLocked = false;
		}
		
	}
}