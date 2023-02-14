package com.kavalok.gameSpiceRacing
{
	public class Config
	{
		static public const MAX_PLAYERS:int = 5;;
		
		static public const FUEL_KOEF:Number = 0.000003;
		static public const FUEL_EMPTY_KOEF:Number = 0.3;
		static public const SPACE_DCC:Number = 0.005;
		
		static public const PAGE_COUNT:int = 50;
		static public const OBJECTS_PER_PAGE:int = 3;
		static public const PLAYER_POSITION:Number = 0.8;
		
		static public const UPDATE_INTERVAL:Number = 0.5; //seconds
		
		static public const DEBUG_PAYERS_COUNT:int = 2;
		static public const DEBUG_REMOTE_ID:String = 'gameDefault';
		
		static public const MONEY_WIN:int = 100;
		static public const MONEY_LOST:int = 10;
	}
}
