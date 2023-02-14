package com.kavalok.constants
{
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	
	public class ResourceBundles
	{
		static public const LOADERS : String = "loaders";
		static public const PETS : String = "pets";
		static public const PET_PHRASES : String = "petPhrases";
		static public const COMPETITIONS : String = "competitions";
		static public const KAVALOK : String = "kavalok";
		static public const TITLES : String = "titles";
		static public const FAMILY : String = "family";
		static public const SERVER_SELECT : String = "serverSelect";
		static public const SAFE_CHAT : String = "safeChat";
		static public const CURRENCIES : String = "currencies";
		static public const BECOME_CITIZEN_DIALOG : String = "bc";
		static public const GRAPHITY:String = 'graphity';
		static public const ROBOTS:String = 'robots';
		static public const ROBOT_ITEMS:String = 'robotItems';
		static public const MAP:String = 'map';
		static public const MOODS:String = 'moods';
		static public const MUSIC:String = 'music';
		static public const BADGES:String = 'badges';
		static public const MOD_SELECT : String = "modSelect";

		public var competitions : ResourceBundle = Localiztion.getBundle(COMPETITIONS);
		public var pets : ResourceBundle = Localiztion.getBundle(PETS);
		public var kavalok : ResourceBundle = Localiztion.getBundle(KAVALOK);
		public var titles : ResourceBundle = Localiztion.getBundle(TITLES);
		public var safeChat : ResourceBundle = Localiztion.getBundle(SAFE_CHAT);
		public var becomeCitizenDialog : ResourceBundle = Localiztion.getBundle(BECOME_CITIZEN_DIALOG);
		public var robots : ResourceBundle = Localiztion.getBundle(ROBOTS);
		public var robotItems : ResourceBundle = Localiztion.getBundle(ROBOT_ITEMS);
		public var currencies : ResourceBundle = Localiztion.getBundle(CURRENCIES);
		public var moods : ResourceBundle = Localiztion.getBundle(MOODS);
		public var music : ResourceBundle = Localiztion.getBundle(MUSIC);
		public var badges : ResourceBundle = Localiztion.getBundle(BADGES);
		public var premium:ResourceBundle = Localiztion.getBundle("premium");
	}
}
