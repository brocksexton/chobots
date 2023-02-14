package com.kavalok.dto
{
	import flash.net.registerClassAlias;
	
	public class ServerPropertiesTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.ServerPropertiesTO", ServerPropertiesTO);
		}

		public var charSet:String 
		public var videoPlayerURL:String;
		public var petHelpURL:String;
		public var termsAndConditionsURL:String;
		public var blogURL:String;
	}
}