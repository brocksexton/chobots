package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	
	public class NotificationCommand extends ServerCommandBase
	{
		override public function execute():void
		{
			Global.charManager.refreshMoney();
			var notify:String = String(parameter);
			//trace(Global.charManager.charId + " received notification " + notify);
			if(notify.indexOf("[A]") != -1){
				var notify2:String = "Agent " + notify.split("[A]")[1];
				if(Global.charManager.isAgent && !(notify.indexOf(Global.charManager.charId) != -1))
				Global.frame.showNotification(notify2, "agent");
			} else {
				Global.frame.showNotification(notify, "mod");
			}
		}
	}
}