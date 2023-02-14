package com.kavalok.pets
{
	import com.kavalok.remoting.DataObject;
	
	public class PetItem extends DataObject
	{
		public var id:int;
		public var name:String;
		public var placement:String;
		public var price:int;
		
		public function PetItem(data:Object):void
		{
			super(data);
		}
	}
}