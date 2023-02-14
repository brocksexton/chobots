package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;
	
	public class AdminStuffItemMessage extends StuffMessageBase
	{
		public var reason:String;

		public function AdminStuffItemMessage():void
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}
		
		override public function getText():String
		{
			return Strings.substitute(Global.messages.stuffItemPresent, reason);
		}
	}
}