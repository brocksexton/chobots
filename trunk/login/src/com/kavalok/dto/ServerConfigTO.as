package com.kavalok.dto
{
	import flash.net.registerClassAlias;
	
	public class ServerConfigTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.ServerConfigTO", ServerConfigTO);
		}

		public var guestsEnabled : Boolean;
		public var registrationEnabled : Boolean;
		public var adyenEnabled : Boolean;

		public function ServerConfigTO()
		{
		}

	}
}