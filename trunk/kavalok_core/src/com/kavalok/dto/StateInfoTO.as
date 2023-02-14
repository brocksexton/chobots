package com.kavalok.dto
{
	import flash.net.registerClassAlias;
	
	public class StateInfoTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.StateInfoTO", StateInfoTO);
		}

		public var state : Object;
		public var connectedChars : Array;

		public function StateInfoTO()
		{
		}

	}
}