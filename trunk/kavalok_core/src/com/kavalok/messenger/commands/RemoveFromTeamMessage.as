package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;

	public class RemoveFromTeamMessage extends MessageBase
	{
		override public function execute():void
		{
			super.execute();
			Global.charManager.robotTeam.refresh();
		}
		
		override public function show():void
		{
			showInfo(Global.messages.message, getText());
		}
		
		override public function getText():String
		{
			return Strings.substitute(
				Global.resourceBundles.robots.messages.removedFromTeamMsg, sender);
		}
		
	}
}