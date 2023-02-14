package com.kavalok.dto.robot
{
	import flash.net.registerClassAlias;
	
	public class RobotScoreTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.robot.RobotScoreTO", RobotScoreTO);
		}
		
		public var rate:int;
		public var name:String;
		public var level:int;
		public var numCombats:int;
		public var numWin:int;
	}
}