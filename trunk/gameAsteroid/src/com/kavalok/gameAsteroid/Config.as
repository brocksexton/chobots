package com.kavalok.gameAsteroid
{
	import com.kavalok.gameplay.KavalokConstants;
	import flash.geom.Rectangle;
	
	public class Config
	{
		static public const BOUNDS:Rectangle = KavalokConstants.SCREEN_RECT;
		
		static public const ITEM_COUNT_START:int = 3;
		static public const ITEM_MIN_V:Number = 3;
		static public const ITEM_MAX_V:Number = 15;
		
		static public const PLYER_SPEED:Number = 5;
		
		static public const SHELL_MAX_DELAY:int = 12;
		static public const SHELL_MIN_DELAY:int = 1;
		static public const SHELL_SPEED:Number = 20;
	}
}
