package com.kavalok.robots
{
	public class RobotTypes
	{
		static public const BODY:String = '#';
		static public const HEAD:String = 'H';
		static public const SHIELD:String = 'S';
		static public const RACK:String = 'R';
		static public const WEAPON:String = 'W';
		
		static public const ARTIFACT:String = 'A';
		static public const SPECIAL_ITEM:String = 'I';
		
		static public const BASE_ITEMS:Array = [HEAD, SHIELD, RACK, WEAPON, BODY];
		static public const CUSTOM_ITEMS:Array = [ARTIFACT, SPECIAL_ITEM];
	}
}