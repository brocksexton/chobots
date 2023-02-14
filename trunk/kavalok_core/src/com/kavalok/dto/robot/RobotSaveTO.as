package com.kavalok.dto.robot
{
	import flash.net.registerClassAlias;
	
	public class RobotSaveTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.robot.RobotSaveTO", RobotSaveTO);
		}
		
		public var id:int;
		public var active:Boolean;
	}
}