package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	
	public class PaidStuffBoughtMessage extends StuffMessageBase
	{			 
				 
		public function PaidStuffBoughtMessage() 
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}
		
		override public function getText():String
		{
			return Global.resourceBundles.kavalok.messages.paidStuffBought;
		}

	}
}