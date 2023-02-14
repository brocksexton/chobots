package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;
	
	public class ExpMessage extends MessageBase
	{			 
				 
		public var exp:int;
	//	public var reason:String;

		public function ExpMessage() 
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "Chobots Team");
		}
		
		override public function getText():String
		{
			return Strings.substitute("You've been rewarded with " + exp + " cho!");
		}
		
		override public function show():void
		{
		  // Global.charManager.experience == Global.charManager.experience + exp;
		//	Global.charManager.refreshExp();
			showInfo(sender, getText());
			Global.addExperience(exp);
		}
		
		override public function getIcon():Class
		{
			return McMsgCoinsIcon;
		}
		

	}
}