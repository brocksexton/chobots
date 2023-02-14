package com.kavalok.gameChopaj.data
{
	import com.kavalok.remoting.DataObject;
	
	public class FireData extends DataObject
	{
		public var power:Number;
		public var direction:Number;
		public var itemIndex:int;
		
		public function FireData(data:Object = null)
		{
			super(data);
		}
	}
	
}