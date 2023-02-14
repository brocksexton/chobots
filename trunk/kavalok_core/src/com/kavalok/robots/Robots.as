package com.kavalok.robots
{
	public class Robots
	{
		static public const MAX_ARTIFACTS:int = 6;
		static public const MAX_SPECIAL_ITEMS:int = 6; 
		
		static public const VBOT:String = 'vbot';
		static public const GBOT:String = 'gbot';
		
		static public function get names():Array 
		{
			return [VBOT, GBOT];
		}
	}
}