package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Strings;
	
	public class RobotTeamFullMessage extends MessageBase
	{
		private var _bundle:ResourceBundle = Global.resourceBundles.robots;
		
		override public function execute():void
		{
			if (!messageExists())
				super.execute();
		}
		
		override public function getText():String
		{
			return Strings.substitute(_bundle.messages.teamOwnerIsFull, sender);
		}
		
		override public function getIcon():Class
		{
			return McMsgCombatIcon;
		}
		
		override public function show():void
		{
			Dialogs.showOkDialog(getText());
		}
	}
}