package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	public class BanDateCommand extends ServerCommandBase
	{
		override public function execute():void
		{
			var banPeriod:int = int(parameter);
			
			var message:String = Strings.substitute(
				Global.messages.adminBanDate, String(banPeriod));
			
			Dialogs.showOkDialog(message);
			Global.charManager.setBan(banPeriod);
		}
	}
}