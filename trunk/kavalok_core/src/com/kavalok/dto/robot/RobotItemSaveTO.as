package com.kavalok.dto.robot
{
	import com.kavalok.robots.RobotTypes;
	import com.kavalok.utils.Strings;
	
	import flash.net.registerClassAlias;
	
	public class RobotItemSaveTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.robot.RobotItemSaveTO", RobotItemSaveTO);
		}
		
		public var id:int;
		public var robotId:int;
		public var position:int;
	}
}