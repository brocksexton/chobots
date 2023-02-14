package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	public class DisableChatCommand extends ServerCommandBase
	{
		
		override public function execute():void
		{
			var banCount:int = int(parameter);
			var banLeftTime:uint = 0;
			var periodConverted:int = 0;
			
			var localMessage:String = Global.messages.adminBanDate;
			switch (banCount)
			{
				case 0:
					periodConverted = 0;
					localMessage = "Your chat has been enabled!";
					banLeftTime=0;
					break;
				case 1: 
					periodConverted = 5;
					localMessage = Global.messages.chatDisabledByAdmin;
					banLeftTime = 5 * 60 * 1000;
					break;
				case 2: 
					periodConverted = 15;
					localMessage = Global.messages.chatDisabledByAdmin;
					banLeftTime = 15 * 60 * 1000;
					break;
				case 3: 
					periodConverted = 12;
					localMessage = Global.messages.chatDisabledByAdminHours;
					banLeftTime = 12 * 60 * 60 * 1000;
					break;
				case 4: 
					periodConverted = 24;
					localMessage = Global.messages.chatDisabledByAdminHours;
					banLeftTime = 24 * 60 * 60 * 1000;
					break;
			}
			
			var message:String = Strings.substitute(localMessage, String(periodConverted));
			
			if(!(banLeftTime == 0))
			Dialogs.showOkDialog(message);
			Global.charManager.setBan(banLeftTime);
		}
	}
}

