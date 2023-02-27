package com.kavalok.constants
{
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.Maths;
	
	public class Locations
	{
		public static function isLocation(id : String) : Boolean
		{
			if (id)
				return id.indexOf('loc') == 0;
			else
				return false;
		}
		
		
		public static const LOC_0 : String = "loc0";
		public static const LOC_1 : String = "loc1";
		public static const LOC_2 : String = "loc2";
		public static const LOC_3 : String = "loc3";
		public static const LOC_5 : String = "loc5";
		public static const LOC_6 : String = "loc6";
		public static const LOC_7 : String = "loc7";
		public static const LOC_8 : String = "loc8";
		public static const LOC_9 : String = "loc9";
		public static const LOC_10 : String = "loc10";
		public static const LOC_11 : String = "loc11";
		public static const LOC_12 : String = "loc12";
		public static const LOC_13 : String = "loc13";
		public static const LOC_32:String = "loc32";
		public static const LOC_ACADEMY : String = "locAcademy";
		public static const LOC_ACADEMY_ROOM : String = "locAcademyRoom";
		public static const LOC_ACC_SHOP : String = "locAccShop";
		public static const LOC_AGENTS:String = "locAgents";
		public static const LOC_BEACH : String = "locBeach";
		public static const LOC_CAFE : String = "locCafe";
		public static const LOC_CHLOS:String = "locChlos";
		public static const LOC_ECO : String = "locEco";
		public static const LOC_ECO_SHOP : String = "locEcoShop";
		public static const LOC_FOREST : String = "locForest";
		public static const LOC_GAMES : String = "locGames";
		public static const LOC_GIRLS:String = "locGirls";
		public static const LOC_GRAPHITY : String = "locGraphity";
		public static const LOC_GRAPHITY_A : String = "locGraphityA";
		public static const LOC_GRAPHITY_M:String = "locGraphityM";
		public static const LOC_MAGIC_SHOP : String = "locMagicShop";
		public static const LOC_MISSIONS : String = "locMissions";
		public static const LOC_MUSIC : String = "locMusic";
		public static const LOC_MUSICSTAGE:String = "locMusicStage";
		public static const LOC_NICHOS1:String = "locNichos1";
		public static const LOC_NICHOS2:String = "locNichos2";
		public static const LOC_NICHOS3:String = "locNichos3";
		public static const LOC_NICHOS4:String = "locNichos4";
		public static const LOC_NICHOS5:String = "locNichos5";
		public static const LOC_NICHOS6:String = "locNichos6";
		public static const LOC_NICHOS7:String = "locNichos7";
		public static const LOC_NICHOS8:String = "locNichos8";
		public static const LOC_NICHOS:String = "locNichos";
		public static const LOC_PARK : String = "locPark";
		public static const LOC_PARTY : String = "locParty";
		public static const LOC_HOMESHOP : String = "locHomeShop";
		public static const LOC_ROBOTS : String = "locRobots";
		public static const LOC_ROPE : String = "locationRope";
		public static const LOC_SANTA:String = "locSanta";
		public static const LOC_SECRET:String = "locSecret";
		public static const LOC_SECRETSHOP:String = "locSecretShop";
		public static const LOC_SPACE:String = "locSpace";
		public static const LOC_STAFF : String = "locStaff";
		public static const LOC_TESTING:String = "locTesting";
		public static const LOC_BUILDING:String = "locBuilding";
		public static const LOC_SHOPCOLOR:String = "locShopColor";
		public static const MISSION_FARM : String = "missionFarm";
		
		public static const LOC_BEACH_FISH:String = "locBeach_fish";
		public static const LOC_PARK_CS5:String = "locPark_CS5";
		
		public static const GAME_GAMEGUITARIDOL : String = "gameGuitarIdol";
		public static const GAME_GARBAGE_COLLECTOR : String = "gameGarbageCollector";
		public static const GAME_MONEY : String = "gameMoney";
		public static const GAME_WORMS : String = "gameSweetBattle";

		public static const LOC_WUT : String = "locWut";

		public static const LOC_SECRET_2 : String = "locSecret2";
		public static const LOC_SECRET_3 : String = "locSecret3";
		public static const LOC_BLISS : String = "locBliss";

		public static const LOC_RADIO : String = "locRadio";


		
		
		public static function getRandomLocation() : String
		{
			return Arrays.randomItem(flushList);
		}
		
		public static function get flushList():Array
		{
			var result:Array = [LOC_0, LOC_1, LOC_2, LOC_3, LOC_5, LOC_ACADEMY, LOC_GAMES, LOC_CAFE, LOC_ACC_SHOP];
			return result;
		}
		
		public static function get list():Array
		{
			var result:Array =
			[ 
						// List to show in Mod Panel for Room Selection
			  			 LOC_0, 
			             LOC_1, 
			             LOC_2, 
			             LOC_3, 
			             LOC_5,
			          //   LOC_6,
			          //   LOC_7,
			          //   LOC_8,
			           //  LOC_9,
			          //   LOC_10,
			            // LOC_11,
			            // LOC_12,
			            // LOC_13,
			             LOC_ACADEMY, 
			             LOC_ACADEMY_ROOM,
			             LOC_ACC_SHOP,
			             LOC_AGENTS,
			             LOC_BEACH,
			           //  LOC_BUILDING,
			             LOC_CAFE,
			           //  LOC_CHLOS,
			             LOC_ECO, 
			             LOC_ECO_SHOP,
			            // LOC_FOREST,
			             LOC_GAMES,
			           //  LOC_GIRLS,
			             LOC_GRAPHITY,
			             LOC_GRAPHITY_A,
						 LOC_GRAPHITY_M,
			             LOC_MAGIC_SHOP,
			             LOC_MISSIONS,
						 LOC_MUSIC,
			             LOC_MUSICSTAGE,
			           /*  LOC_NICHOS,
			             LOC_NICHOS1,
			             LOC_NICHOS2,
			             LOC_NICHOS3,
			             LOC_NICHOS4,
			             LOC_NICHOS5,
			             LOC_NICHOS6,
			             LOC_NICHOS7,
			             LOC_NICHOS8,	*/
			             LOC_PARK,
			             LOC_PARTY,
			             LOC_ROBOTS,
			             LOC_ROPE, 
					//     LOC_SANTA,
			           //  LOC_SECRET,
			           //  LOC_STAFF,
			          //   LOC_SPACE,
			           //  LOC_TESTING,
			 			LOC_BEACH_FISH,
						LOC_PARK_CS5,

						
			];
			
			return result;
		}
	}
}