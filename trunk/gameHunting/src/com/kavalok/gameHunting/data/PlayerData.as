package com.kavalok.gameHunting.data
{
	import com.kavalok.remoting.DataObject;
	
	public class PlayerData extends DataObject
	{
		public var charId:String;
		public var clothes:Array;
		public var body:String;
		public var color:int;
		public var health:int = 100;
		
		public function PlayerData(data:Object = null):void
		{
			super(data);
		}
	}
	
}