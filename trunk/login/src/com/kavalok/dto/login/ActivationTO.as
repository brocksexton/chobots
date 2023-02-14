package com.kavalok.dto.login
{
	import flash.net.registerClassAlias;
	
	public class ActivationTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.login.ActivationTO", ActivationTO);
		}
		
		public var email : String;
		public var parent : Boolean;

  		public function ActivationTO()
		{
		}

	}
}