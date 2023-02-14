package com.kavalok.gameSweetBattle 
{
	import org.rje.glaze.engine.dynamics.Material;
	
	public class Config 
	{
		public static const PLAYER_SCALE:Number = 0.7;
		public static const STAGE_COUNT:int = 1;
		public static const MAX_PLAYERS:int = 4;
		public static const ACTION_TIME:int = 15;
		public static const POST_ACTION_TIME:int = 3;
		public static const PLAYER_HEALTH:int = 100;
		public static const PLAYER_SPEED:int = 2;
		
		public static const GAME_WIDTH:int = 900;
		public static const GAME_HEIGHT:int = 510;
		
//		public static const STAGE_WIDTH:int = 720 * 2;
		public static const STAGE_HEIGHT:int = 510;
		
		public static const DEFAULT_MATERIAL : Material = new Material(DEF_ELAST, DEF_FRICTION, DEF_DENSITY);
		public static const DEF_MASS:Number = 0.1;
		public static const DEF_DENSITY:Number = 1;
		public static const DEF_INERT:Number = 10;
		public static const DEF_ELAST:Number = 0.5;
		public static const DEF_FRICTION:Number = 1;
	}
}