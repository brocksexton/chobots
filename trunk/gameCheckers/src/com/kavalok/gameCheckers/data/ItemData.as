package com.kavalok.gameCheckers.data
{
	import com.kavalok.remoting.DataObject;
	
	public class ItemData extends DataObject
	{
		public var index:int;
		public var row:int;
		public var col:int;
		public var playerNum:int;
		public var isKing:Boolean = false;
		
		public function ItemData(data:Object = null):void
		{
			super(data);
		}
	}
	
}