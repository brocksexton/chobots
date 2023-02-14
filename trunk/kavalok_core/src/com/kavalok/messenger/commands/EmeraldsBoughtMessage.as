package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;
	
	public class EmeraldsBoughtMessage extends MessageBase
	{			 
				 
		public var emeralds:int;
		public var reason:String;

		public function EmeraldsBoughtMessage() 
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}
		
		override public function getText():String
		{
			return Strings.substitute(Global.resourceBundles.kavalok.messages.emeraldsBought, emeralds, reason);
		}
		
		override public function show():void
		{
			Global.charManager.refreshEmeralds();
			showInfo(sender, getText());
		}
		
		override public function getIcon():Class
		{
			return McMsgEmeraldsIcon;
		}
		

	}
}