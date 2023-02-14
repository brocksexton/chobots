package com.kavalok.dto.robot
{
	import flash.net.registerClassAlias;
	
	public class CombatResultTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.robot.CombatResultTO", CombatResultTO);
		}
		
		public var userId:int;
		public var affected:Boolean;
		public var blocked:Boolean;
		public var damage:int;
		public var repair:int;
		
		public var attackDirection:String;
		public var specialItemId:int;
		
		public var finished:Boolean;
		public var energy:int;
		public var experience:int;
		public var level:int;
		
		public function CombatResultTO()
		{
		}
	}
}