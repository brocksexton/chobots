package com.kavalok.dto.robot
{
	import flash.net.registerClassAlias;
	
	public class CombatActionTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.robot.CombatActionTO", CombatActionTO);
		}
		
		public var attackDirection:String = null;
		public var shieldDirection:String = null;
		public var specialItemId:int = -1;
		
		public function CombatActionTO()
		{
		}
	}
}