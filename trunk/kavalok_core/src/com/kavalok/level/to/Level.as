package com.kavalok.level.to
{
	public class Level
	{
		
		private var _itemName:String;
		private var _levelNumber:int;
		private var _placement:String;
		private var _itemId:int;
		
		public function Level(itemName:String, levelNumber:int, placement:String, itemId:int)
		{
			_itemName = itemName;
			_itemId = itemId;
			_levelNumber = levelNumber;
			_placement = placement;
		}

		public function get itemName():String
		{
			return _itemName;
		}

		public function get itemId():int
		{
			return _itemId;
		}

		public function set itemId(value:int):void
		{
			_itemId = value;
		}

		public function get placement():String
		{
			return _placement;
		}
		
		public function set placement(e:String):void
		{
			_placement = e;
		}

		public function get levelNumber():int
		{
			return _levelNumber;
		}

		public function set levelNumber(value:int):void
		{
			_levelNumber = value;
		}

	}
}