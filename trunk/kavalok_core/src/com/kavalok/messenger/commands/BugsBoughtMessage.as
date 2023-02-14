package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;
	
	public class BugsBoughtMessage extends MessageBase
	{			 
				 
		public var bugs:int;
		public var reason:String;

		public function BugsBoughtMessage() 
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}
		
		override public function getText():String
		{
			return Strings.substitute(Global.resourceBundles.kavalok.messages.bugsBought, bugs, reason);
		}
		
		override public function show():void
		{
			Global.charManager.refreshMoney();
			showInfo(sender, getText());
		}
		
		override public function getIcon():Class
		{
			return McMsgCoinsIcon;
		}
		

	}
}