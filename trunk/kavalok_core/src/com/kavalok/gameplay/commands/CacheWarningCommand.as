package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.remoting.RemoteConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.kavalok.dialogs.Dialogs;
	
	public class CacheWarningCommand
	{
		private var _message:String
		private var _okHandler:Function;
		private var _source:String;
		
		public function CacheWarningCommand(source:String, message:String = null, onOk:Function = null)
		{
			_message = "It looks like you're playing on an old version of Chobots! Please clear your cache to continue playing. \n\n Would you like to find out more information?";
			_okHandler = onOk;
			_source = source;
		}
		
		public function execute():void
		{
			/*if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
			}
			else
			*///{
				var text:String = _message;
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
				dialog.yes.addListener(onOk);
				dialog.no.addListener(onNo);
			//}
		}

		private function onNo():void
		{
			RemoteConnection.instance.disconnect();
			navigateToURL(new URLRequest("http://chobots.net/play"), "_self");
			Dialogs.showOkDialog("Disconnected.", false);
		}
		
		private function onOk():void
		{
			RemoteConnection.instance.disconnect();
			Dialogs.showOkDialog("Redirecting...", false);
				navigateToURL(new URLRequest("http://blog.chobots.net/p/clear-your-cache.html"), "_self");
			
			if (_okHandler != null)
				_okHandler();
		}
	
	}
}