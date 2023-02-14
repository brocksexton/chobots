package com.kavalok.dto.home
{
	import flash.net.registerClassAlias;
	
	public class CharHomeTO
	{
		public static const BIG_ROOM : uint = 1;
		
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.home.CharHomeTO", CharHomeTO);
		}
		
		public var citizen : Boolean;
		public var items : Array;
		public var crit : String;
		public var furniture : Array;
		public var robotExists : Boolean;
		public var rep:int;
		
		
	}
}