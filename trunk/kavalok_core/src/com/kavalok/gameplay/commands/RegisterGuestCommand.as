package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.constants.BrowserConstants;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class RegisterGuestCommand
	{
		public function execute():void
		{
			if (Global.charManager.isGuest)
			{
				var message:String = Global.messages.registerPlease;
				
				var link:String = Strings.substitute("<u><a href='{0}' target='_blank'>{1}</a></u>", redirectURL, 'www.chobots.com');
				
				message = Strings.substitute(message, link);
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(message);
				dialog.yes.addListener(onOk);
			}
			else if (Global.charManager.isNotActivated)
			{
				Global.frame.tips.visible = false;
				Global.moduleManager.loadModule("login", {showActivation: "true", login: Global.charManager.charId});
			}
		}
		
		private function onOk():void
		{
			var request:URLRequest = new URLRequest(redirectURL);
			try
			{
				navigateToURL(request, BrowserConstants.SELF);
			}
			catch (e:Error)
			{
				trace(e.message);
				navigateToURL(request, BrowserConstants.BLANK);
			}
		}
		
		public function get redirectURL():String
		{
			var url:String = Global.MAIN_SITE_URL;
			if (Global.referer)
				url += '?src=' + Global.referer;
			
			return url;
		}
	}
}