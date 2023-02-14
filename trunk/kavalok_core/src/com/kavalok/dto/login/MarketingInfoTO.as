package com.kavalok.dto.login
{
	import flash.net.registerClassAlias;
	
	public class MarketingInfoTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.login.MarketingInfoTO", MarketingInfoTO);
		}

		public var campaign : String;
		public var source : String;
		public var keywords : String;
		public var referrer : String;
		public var partner : String;
		public var activationUrl : String;
		
		public function MarketingInfoTO()
		{
		}

	}
}