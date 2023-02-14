package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	
	public class ShowRulesCommand extends CharCommandBase
	{
		override public function execute():void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(Global.messages.warnUserConfirmation);
			dialog.yes.addListener(onWarnUserAccept);
		}
		
		private function onWarnUserAccept():void
		{
			new AdminService().sendAgentRules(char.userId);
			new LogService().toolsLog("Warned", char.userId, charId, "agent");
			new AdminService().addPanelLog("[A] " + Global.upperCase(Global.charManager.charId), "Warned " + charId, Global.getPanelDate());
			//new AdminService().reportUser(char.userId, "WARNING RECEIVED FROM " + Global.userName + "\n\n" + getReportText(char.id));
		}
		
		private function getReportText(login:String):String
		{
			var text:String = '';
			
			var chatHistory:Array = Global.notifications.stack;
			if (chatHistory.length == 0)
				return ""; //Ticket #3549
			for each (var notification:Notification in chatHistory)
			{
				text += notification.fromLogin + ': ' + notification.message + '\n';
			}
			return text;
		}
	}

}