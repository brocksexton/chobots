package com.kavalok.gameChopaj.data
{
	import com.kavalok.remoting.DataObject;
	
	public class PlayerData extends DataObject
	{
		public var userId:int;
		public var id:String;
		public var body:String;
		public var color:int;
		public var clothes:Array;
		public var tool:String;
		public var playerNum:int;
		public var rowNum:int;
		
		public function PlayerData(data:Object = null)
		{
			super(data);
		}
		
	}
	
}