package com.kavalok.dto.stuff
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	public class StuffTypeTO extends StuffTOBase
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.stuff.StuffTypeTO", StuffTypeTO);
		}

		public var placement : String;
		public var enabled : Boolean;
		public var robotInfo : Object;
		public var skuInfo : Object;
		public var otherInfo:*;

	}
}