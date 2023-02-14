package com.kavalok.dto.robot
{
	import flash.net.registerClassAlias;
	
	public class RobotTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.robot.RobotTO", RobotTO);
		}
		
		public var id:int;
		public var name:String;
		public var experience:int;
		public var active:Boolean;
		public var items:Array;
		public var level:int;
		public var energy:int;
		public var superCombination:String;
		
		public function RobotTO()
		{
		}
	}
}