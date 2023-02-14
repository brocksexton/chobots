package com.kavalok.dto
{
	import flash.net.registerClassAlias;
	
	public class WorldConfigTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.WorldConfigTO", WorldConfigTO);
		}

		public var safeModeEnabled : Boolean;
		public var drawingEnabled : Boolean;
		

		public function WorldConfigTO()
		{
		}

	}
}