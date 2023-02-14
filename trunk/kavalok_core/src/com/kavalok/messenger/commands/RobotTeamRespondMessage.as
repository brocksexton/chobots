package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Strings;
	
	public class RobotTeamRespondMessage extends MessageBase
	{
		private var _bundle:ResourceBundle = Global.resourceBundles.robots;
		
		override public function execute():void
		{
			if (!messageExists())
				super.execute();
			Global.charManager.robotTeam.refresh();
		}
		
		override public function getText():String
		{
			return Strings.substitute(_bundle.messages.teamMemberAdded, sender);
		}
		
		override public function getIcon():Class
		{
			return McMsgCombatIcon;
		}
		
		override public function show():void
		{
			showInfo(Global.messages.message, getText());
		}
	}
}