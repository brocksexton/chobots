package com.kavalok.gameChess.data
{
	import com.kavalok.remoting.DataObject;
	
	public class ItemData extends DataObject
	{
		public var id:int;
		public var row:int;
		public var col:int;
		public var playerNum:int;
		public var type:String;
		
		public function ItemData(data:Object = null):void
		{
			super(data);
		}
	}
	
}