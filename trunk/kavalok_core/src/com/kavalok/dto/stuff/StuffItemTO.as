package com.kavalok.dto.stuff
{
	import flash.net.registerClassAlias;
	
	public class StuffItemTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.stuff.StuffItemTO", StuffItemTO);
		}

		public var id : int;
		
		public var x : int;
		
		public var y : int;
		
		public var level : int;

		public var rotation : int;
		
		public var color : int;
		
		public var used : Boolean;
		
		public var type : StuffTypeTO;
	}
}