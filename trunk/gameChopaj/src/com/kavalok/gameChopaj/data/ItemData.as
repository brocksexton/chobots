package com.kavalok.gameChopaj.data
{
	import com.kavalok.remoting.DataObject;
	
	public class ItemData extends DataObject
	{
		public var index:int;
		public var x:Number;
		public var y:Number;
		public var playerNum:int;
		
		public function ItemData(data:Object = null):void
		{
			super(data);
		}
	}
	
}