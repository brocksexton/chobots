package com.kavalok.dto.robot
{
	import flash.net.registerClassAlias;
	
	public class RobotTeamScoreTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.robot.RobotTeamScoreTO", RobotTeamScoreTO);
		}
		
		public var rate:int;
		public var name:String;
		public var color:int;
		public var numCombats:int;
		public var numWin:int;
	}
}